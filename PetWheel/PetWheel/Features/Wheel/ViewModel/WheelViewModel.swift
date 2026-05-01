import Foundation
import Combine
import SwiftUI

final class WheelViewModel: ObservableObject {
    @Published private(set) var activities: [PetActivity] = PetActivity.all
    @Published private(set) var isSpinning: Bool = false
    @Published private(set) var selectedActivity: PetActivity?
    @Published private(set) var rotationAngle: Double = 0
    @Published private(set) var showResult: Bool = false

    private let coordinator: WheelCoordinator
    private var spinTask: Task<Void, Never>?

    var pet: Pet { coordinator.pet }

    init(coordinator: WheelCoordinator) {
        self.coordinator = coordinator
    }

    func spin() {
        guard !isSpinning else { return }

        selectedActivity = nil
        showResult = false
        isSpinning = true

        let targetIndex = Int.random(in: 0..<activities.count)
        let sliceDegrees = 360.0 / Double(activities.count)
        let targetAngle = sliceDegrees * Double(targetIndex)
        let fullSpins = Double.random(in: 5...8) * 360
        let finalAngle = rotationAngle + fullSpins + (360 - targetAngle)

        withAnimation(.easeInOut(duration: 3.5)) {
            rotationAngle = finalAngle
        }

        spinTask = Task {
            try? await Task.sleep(nanoseconds: 3_600_000_000)
            await MainActor.run {
                selectedActivity = activities[targetIndex]
                isSpinning = false
                showResult = true
            }
        }
    }

    func recordActivity() {
        guard let activity = selectedActivity else { return }
        let recorded = PetActivity(name: activity.name, emoji: activity.emoji)
        coordinator.recordActivity(recorded)
        showResult = false
        selectedActivity = nil
    }

    func dismissResult() {
        showResult = false
        selectedActivity = nil
    }

    deinit {
        spinTask?.cancel()
    }
}
