import XCTest
@testable import PetWheel

final class PetModelTests: XCTestCase {

    func testPetInitialization() {
        let pet = Pet(name: "Buddy", type: .dog)
        XCTAssertEqual(pet.name, "Buddy")
        XCTAssertEqual(pet.type, .dog)
        XCTAssertNil(pet.birthday)
        XCTAssertTrue(pet.notes.isEmpty)
        XCTAssertTrue(pet.activityHistory.isEmpty)
    }

    func testPetAgeCalculation() {
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let pet = Pet(name: "Max", type: .cat, birthday: oneYearAgo)
        XCTAssertEqual(pet.age, "1 yr")
    }

    func testPetAgeNilWhenNoBirthday() {
        let pet = Pet(name: "Fluffy", type: .rabbit)
        XCTAssertNil(pet.age)
    }

    func testPetTypeEmojis() {
        XCTAssertEqual(PetType.dog.emoji, "🐕")
        XCTAssertEqual(PetType.cat.emoji, "🐈")
        XCTAssertEqual(PetType.rabbit.emoji, "🐇")
    }

    func testPetTypeDisplayName() {
        XCTAssertEqual(PetType.dog.displayName, "Dog")
        XCTAssertEqual(PetType.cat.displayName, "Cat")
    }

    func testPetCodable() throws {
        let pet = Pet(name: "Rex", type: .dog, notes: "Loves walks")
        let data = try JSONEncoder().encode(pet)
        let decoded = try JSONDecoder().decode(Pet.self, from: data)
        XCTAssertEqual(pet.id, decoded.id)
        XCTAssertEqual(pet.name, decoded.name)
        XCTAssertEqual(pet.type, decoded.type)
        XCTAssertEqual(pet.notes, decoded.notes)
    }

    func testPetActivityAll() {
        XCTAssertFalse(PetActivity.all.isEmpty)
    }
}
