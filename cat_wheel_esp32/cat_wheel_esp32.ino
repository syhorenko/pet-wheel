/**
 * Cat Wheel Tracker — ESP32 Firmware
 * 
 * Architecture:
 *   - Hall sensor on GPIO4 triggers interrupt on FALLING edge
 *   - Rotation count persisted to NVS every NVS_WRITE_INTERVAL rotations
 *   - BLE GATT service exposes count + reset command to mobile app
 * 
 * BLE Protocol:
 *   Service UUID:          4FAFC201-1FB5-459E-8FCC-C5C9C331914B
 *   Char — rotationCount:  BEB5483E-36E1-4688-B7F5-EA07361B26A8  [READ + NOTIFY]
 *   Char — resetCount:     BEB5483F-36E1-4688-B7F5-EA07361B26A8  [WRITE]
 * 
 * Data format (rotationCount characteristic):
 *   4 bytes, uint32, little-endian
 *   e.g. count=1000 → 0xE8 0x03 0x00 0x00
 */

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Preferences.h>

// ─── Pin config ────────────────────────────────────────────────────────────
#define HALL_PIN 4

// ─── Tuning constants ──────────────────────────────────────────────────────
#define DEBOUNCE_MS         50    // ignore triggers within this window (ms)
#define NVS_WRITE_INTERVAL  10    // persist to flash every N rotations
#define BLE_NOTIFY_INTERVAL 500   // send BLE notification every N ms

// ─── BLE UUIDs ─────────────────────────────────────────────────────────────
#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHAR_COUNT_UUID     "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHAR_RESET_UUID     "beb5483f-36e1-4688-b7f5-ea07361b26a8"

// ─── State ─────────────────────────────────────────────────────────────────
Preferences prefs;

volatile uint32_t rotationCount = 0;
volatile unsigned long lastTrigger = 0;
volatile bool countDirty = false;   // true when count changed since last NVS write

bool bleClientConnected = false;
bool bleClientWasConnected = false;

BLEServer* bleServer = nullptr;
BLECharacteristic* countCharacteristic = nullptr;

unsigned long lastBleNotify = 0;
uint32_t lastNvsSavedCount = 0;


// ─── Interrupt — runs on every magnet pass ─────────────────────────────────
void IRAM_ATTR onMagnetDetected() {
  unsigned long now = millis();
  if (now - lastTrigger > DEBOUNCE_MS) {
    rotationCount++;
    lastTrigger = now;
    countDirty = true;
  }
}


// ─── NVS helpers ───────────────────────────────────────────────────────────
void loadCountFromNVS() {
  prefs.begin("wheel", false);
  rotationCount = prefs.getUInt("count", 0);
  lastNvsSavedCount = rotationCount;
  Serial.printf("[NVS] Loaded count: %u\n", rotationCount);
}

void saveCountToNVS(uint32_t count) {
  prefs.putUInt("count", count);
  lastNvsSavedCount = count;
  Serial.printf("[NVS] Saved count: %u\n", count);
}

void resetCountInNVS() {
  rotationCount = 0;
  saveCountToNVS(0);
  Serial.println("[NVS] Count reset to 0");
}


// ─── BLE server callbacks ──────────────────────────────────────────────────
class ServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* server) override {
    bleClientConnected = true;
    Serial.println("[BLE] Client connected");
  }

  void onDisconnect(BLEServer* server) override {
    bleClientConnected = false;
    bleClientWasConnected = true;  // signal loop() to restart advertising
    Serial.println("[BLE] Client disconnected");
  }
};


// ─── BLE write callback — app sends reset command ─────────────────────────
class ResetCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* characteristic) override {
    String value = characteristic->getValue().c_str();

    // App writes "RESET" to reset the counter
    if (value == "RESET") {
      resetCountInNVS();
      Serial.println("[BLE] Reset command received from app");
    } else {
      Serial.printf("[BLE] Unknown write value: %s\n", value.c_str());
    }
  }
};


// ─── BLE setup ─────────────────────────────────────────────────────────────
void setupBLE() {
  BLEDevice::init("CatWheel");

  bleServer = BLEDevice::createServer();
  bleServer->setCallbacks(new ServerCallbacks());

  BLEService* service = bleServer->createService(SERVICE_UUID);

  // Rotation count characteristic — READ + NOTIFY
  countCharacteristic = service->createCharacteristic(
    CHAR_COUNT_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  countCharacteristic->addDescriptor(new BLE2902()); // required for NOTIFY

  // Reset characteristic — WRITE only
  BLECharacteristic* resetCharacteristic = service->createCharacteristic(
    CHAR_RESET_UUID,
    BLECharacteristic::PROPERTY_WRITE
  );
  resetCharacteristic->setCallbacks(new ResetCallbacks());

  service->start();

  BLEAdvertising* advertising = BLEDevice::getAdvertising();
  advertising->addServiceUUID(SERVICE_UUID);
  advertising->setScanResponse(true);
  BLEDevice::startAdvertising();

  Serial.println("[BLE] Advertising as 'CatWheel'");
}


// ─── Send current count over BLE notify ────────────────────────────────────
void notifyCount(uint32_t count) {
  // Pack uint32 as 4 bytes little-endian
  uint8_t data[4] = {
    (uint8_t)(count & 0xFF),
    (uint8_t)((count >> 8) & 0xFF),
    (uint8_t)((count >> 16) & 0xFF),
    (uint8_t)((count >> 24) & 0xFF)
  };
  countCharacteristic->setValue(data, 4);
  countCharacteristic->notify();
}


// ─── Setup ─────────────────────────────────────────────────────────────────
void setup() {
  Serial.begin(115200);
  Serial.println("\n[BOOT] Cat Wheel Tracker starting...");

  // Restore count from flash
  loadCountFromNVS();

  // Hall sensor — interrupt on FALLING (HIGH→LOW = magnet present)
  pinMode(HALL_PIN, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(HALL_PIN), onMagnetDetected, FALLING);
  Serial.println("[SENSOR] Hall sensor ready on GPIO4");

  // Start BLE
  setupBLE();

  Serial.printf("[READY] Counting from %u\n", rotationCount);
}


// ─── Loop ──────────────────────────────────────────────────────────────────
void loop() {

  // 1. Persist to NVS if count changed by NVS_WRITE_INTERVAL
  if (countDirty) {
    uint32_t current = rotationCount; // snapshot (volatile read)
    if (current - lastNvsSavedCount >= NVS_WRITE_INTERVAL) {
      saveCountToNVS(current);
      countDirty = false;
    }
  }

  // 2. Send BLE notification on interval (only if client connected)
  if (bleClientConnected) {
    unsigned long now = millis();
    if (now - lastBleNotify >= BLE_NOTIFY_INTERVAL) {
      notifyCount(rotationCount);
      lastBleNotify = now;

      // Also update READ value so app gets correct count on fresh connect
      uint32_t count = rotationCount;
      uint8_t data[4] = {
        (uint8_t)(count & 0xFF),
        (uint8_t)((count >> 8) & 0xFF),
        (uint8_t)((count >> 16) & 0xFF),
        (uint8_t)((count >> 24) & 0xFF)
      };
      countCharacteristic->setValue(data, 4);
    }
  }

  // 3. Restart advertising after disconnect (so app can reconnect)
  if (bleClientWasConnected && !bleClientConnected) {
    delay(500); // short pause before restart
    BLEDevice::startAdvertising();
    bleClientWasConnected = false;
    Serial.println("[BLE] Restarted advertising");
  }
}
