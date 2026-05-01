import XCTest
@testable import PetWheel

final class WheelViewModelTests: XCTestCase {

    func testInitialState() {
        let pet = Pet(name: "Buddy", type: .dog)
        let coordinator = WheelCoordinator(pet: pet, petService: PetService.shared)
        let vm = WheelViewModel(coordinator: coordinator)

        XCTAssertFalse(vm.isSpinning)
        XCTAssertNil(vm.selectedActivity)
        XCTAssertFalse(vm.showResult)
        XCTAssertEqual(vm.rotationAngle, 0)
        XCTAssertEqual(vm.activities.count, PetActivity.all.count)
    }

    func testSpinStartsSpinning() {
        let pet = Pet(name: "Buddy", type: .dog)
        let coordinator = WheelCoordinator(pet: pet, petService: PetService.shared)
        let vm = WheelViewModel(coordinator: coordinator)

        vm.spin()
        XCTAssertTrue(vm.isSpinning)
    }

    func testSpinDoesNotStartWhenAlreadySpinning() {
        let pet = Pet(name: "Buddy", type: .dog)
        let coordinator = WheelCoordinator(pet: pet, petService: PetService.shared)
        let vm = WheelViewModel(coordinator: coordinator)

        vm.spin()
        let rotationAfterFirst = vm.rotationAngle
        vm.spin()
        XCTAssertEqual(vm.rotationAngle, rotationAfterFirst)
    }

    func testDismissResultClearsState() {
        let pet = Pet(name: "Buddy", type: .dog)
        let coordinator = WheelCoordinator(pet: pet, petService: PetService.shared)
        let vm = WheelViewModel(coordinator: coordinator)

        vm.dismissResult()
        XCTAssertFalse(vm.showResult)
        XCTAssertNil(vm.selectedActivity)
    }
}
