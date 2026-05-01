import Foundation
import Combine

final class PetDetailViewModel: ObservableObject {
    @Published private(set) var pet: Pet
    @Published var isEditing = false
    @Published var editedName: String = ""
    @Published var editedNotes: String = ""

    private let petService: PetService
    private var cancellables = Set<AnyCancellable>()

    init(pet: Pet, petService: PetService) {
        self.pet = pet
        self.petService = petService
        bind()
    }

    private func bind() {
        petService.$pets
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] pets in
                pets.first { $0.id == self?.pet.id }
            }
            .assign(to: \.pet, on: self)
            .store(in: &cancellables)
    }

    func startEditing() {
        editedName = pet.name
        editedNotes = pet.notes
        isEditing = true
    }

    func saveEdits() {
        var updated = pet
        updated.name = editedName.trimmingCharacters(in: .whitespaces)
        updated.notes = editedNotes
        petService.update(updated)
        isEditing = false
    }

    func cancelEditing() {
        isEditing = false
    }

    func delete() {
        petService.delete(pet)
    }

    var recentActivities: [PetActivity] {
        Array(pet.activityHistory.prefix(10))
    }
}
