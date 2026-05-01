import XCTest
@testable import PetWheel

final class AddPetViewModelTests: XCTestCase {

    func testCanSaveReturnsFalseWhenNameIsEmpty() {
        let coordinator = AddPetCoordinator(petService: PetService.shared)
        let vm = AddPetViewModel(coordinator: coordinator)
        vm.name = ""
        XCTAssertFalse(vm.canSave)
    }

    func testCanSaveReturnsFalseForWhitespaceOnlyName() {
        let coordinator = AddPetCoordinator(petService: PetService.shared)
        let vm = AddPetViewModel(coordinator: coordinator)
        vm.name = "   "
        XCTAssertFalse(vm.canSave)
    }

    func testCanSaveReturnsTrueWithValidName() {
        let coordinator = AddPetCoordinator(petService: PetService.shared)
        let vm = AddPetViewModel(coordinator: coordinator)
        vm.name = "Buddy"
        XCTAssertTrue(vm.canSave)
    }

    func testDefaultValues() {
        let coordinator = AddPetCoordinator(petService: PetService.shared)
        let vm = AddPetViewModel(coordinator: coordinator)
        XCTAssertTrue(vm.name.isEmpty)
        XCTAssertEqual(vm.selectedType, .dog)
        XCTAssertFalse(vm.hasBirthday)
        XCTAssertTrue(vm.notes.isEmpty)
    }
}
