import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published private(set) var pets: [Pet] = []
    @Published var searchText: String = ""

    private let petService: PetService
    private weak var coordinator: HomeCoordinator?
    private var cancellables = Set<AnyCancellable>()

    var filteredPets: [Pet] {
        guard !searchText.isEmpty else { return pets }
        return pets.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.type.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }

    init(petService: PetService, coordinator: HomeCoordinator) {
        self.petService = petService
        self.coordinator = coordinator
        bind()
    }

    private func bind() {
        petService.$pets
            .receive(on: DispatchQueue.main)
            .assign(to: \.pets, on: self)
            .store(in: &cancellables)
    }

    func selectPet(_ pet: Pet) {
        coordinator?.navigateToPetDetail(pet)
    }

    func delete(_ pet: Pet) {
        petService.delete(pet)
    }
}
