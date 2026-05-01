import SwiftUI

final class AddPetCoordinator: ObservableObject {
    let petService: PetService

    init(petService: PetService) {
        self.petService = petService
    }

    func save(_ pet: Pet) {
        petService.add(pet)
    }
}

struct AddPetCoordinatorView: View {
    @ObservedObject var coordinator: AddPetCoordinator
    let onDismiss: () -> Void

    var body: some View {
        AddPetView(
            viewModel: AddPetViewModel(coordinator: coordinator),
            onDismiss: onDismiss
        )
    }
}
