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
            ZStack {
                Color.appBackground.ignoresSafeArea()

                if coordinator.petService.pets.isEmpty {
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(Color.neonPurple.opacity(0.10))
                                .frame(width: 100, height: 100)
                            Circle()
                                .strokeBorder(Color.neonPurple.opacity(0.22), lineWidth: 1)
                                .frame(width: 100, height: 100)
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 38))
                                .foregroundStyle(Color.neonPurple.opacity(0.7))
                        }
                        Text("Add a pet first to use the wheel!")
                            .font(.headline)
                            .foregroundStyle(Color.mutedText)
                            .multilineTextAlignment(.center)
                        Button("Add a Pet") { coordinator.showAddPet() }
                            .primaryButtonStyle()
                            .frame(maxWidth: 220)
                    }
                    .padding()
                } else {
                    WheelPetPickerView(coordinator: coordinator)
                }
            }
            .navigationTitle("Activity Wheel")
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
                    .foregroundStyle(Color.mutedText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)

                ForEach(coordinator.petService.pets) { pet in
                    Button {
                        coordinator.showWheel(for: pet)
                    } label: {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.neonPurple.opacity(0.15))
                                    .frame(width: 52, height: 52)
                                Circle()
                                    .strokeBorder(Color.neonPurple.opacity(0.28), lineWidth: 1)
                                    .frame(width: 52, height: 52)
                                Text(pet.type.emoji).font(.title2)
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text(pet.name)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(pet.type.displayName)
                                    .font(.caption)
                                    .foregroundStyle(Color.mutedText)
                            }
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color.neonPurple)
                        }
                        .padding(16)
                        .cardStyle()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
    }
}
