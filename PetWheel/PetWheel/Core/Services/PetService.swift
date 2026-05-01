import Foundation
import Combine

final class PetService: ObservableObject {
    static let shared = PetService()

    @Published private(set) var pets: [Pet] = []

    private let storageKey = "saved_pets"

    private init() {
        load()
    }

    func add(_ pet: Pet) {
        pets.append(pet)
        save()
    }

    func update(_ pet: Pet) {
        guard let index = pets.firstIndex(where: { $0.id == pet.id }) else { return }
        pets[index] = pet
        save()
    }

    func delete(_ pet: Pet) {
        pets.removeAll { $0.id == pet.id }
        save()
    }

    func addActivity(_ activity: PetActivity, to petID: UUID) {
        guard let index = pets.firstIndex(where: { $0.id == petID }) else { return }
        pets[index].activityHistory.insert(activity, at: 0)
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(pets) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let saved = try? JSONDecoder().decode([Pet].self, from: data)
        else { return }
        pets = saved
    }
}
