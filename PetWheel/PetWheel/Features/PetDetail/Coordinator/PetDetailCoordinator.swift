import SwiftUI

final class PetDetailCoordinator: ObservableObject {
    let petService: PetService

    init(petService: PetService) {
        self.petService = petService
    }
}
