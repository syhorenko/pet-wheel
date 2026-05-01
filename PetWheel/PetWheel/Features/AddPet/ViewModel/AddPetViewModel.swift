import Foundation

final class AddPetViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedType: PetType = .dog
    @Published var birthday: Date = Date()
    @Published var hasBirthday: Bool = false
    @Published var notes: String = ""

    private let coordinator: AddPetCoordinator

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    init(coordinator: AddPetCoordinator) {
        self.coordinator = coordinator
    }

    func save() {
        let pet = Pet(
            name: name.trimmingCharacters(in: .whitespaces),
            type: selectedType,
            birthday: hasBirthday ? birthday : nil,
            notes: notes
        )
        coordinator.save(pet)
    }
}
