import SwiftUI

final class WheelCoordinator: ObservableObject {
    let pet: Pet
    let petService: PetService

    init(pet: Pet, petService: PetService) {
        self.pet = pet
        self.petService = petService
    }

    func recordActivity(_ activity: PetActivity) {
        petService.addActivity(activity, to: pet.id)
    }
}

struct WheelCoordinatorView: View {
    @ObservedObject var coordinator: WheelCoordinator
    let onDismiss: () -> Void

    var body: some View {
        WheelView(
            viewModel: WheelViewModel(coordinator: coordinator),
            onDismiss: onDismiss
        )
    }
}

struct WheelTabView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        NavigationStack {
            if coordinator.petService.pets.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "pawprint.circle")
                        .font(.system(size: 64))
                        .foregroundStyle(.secondary)
                    Text("Add a pet first to use the wheel!")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Add a Pet") { coordinator.showAddPet() }
                        .primaryButtonStyle()
                        .frame(maxWidth: 200)
                }
                .padding()
                .navigationTitle("Activity Wheel")
            } else {
                WheelPetPickerView(coordinator: coordinator)
            }
        }
    }
}

struct WheelPetPickerView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Pick a pet to spin for!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)

                ForEach(coordinator.petService.pets) { pet in
                    Button {
                        coordinator.showWheel(for: pet)
                    } label: {
                        HStack(spacing: 16) {
                            Text(pet.type.emoji).font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(pet.name).font(.headline).foregroundStyle(.primary)
                                Text(pet.type.displayName).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.accent)
                        }
                        .padding(16)
                        .cardStyle()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .navigationTitle("Activity Wheel")
    }
}
