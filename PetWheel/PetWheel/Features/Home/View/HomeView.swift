import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator

    var body: some View {
        Group {
            if viewModel.pets.isEmpty {
                EmptyPetsView()
            } else {
                petList
            }
        }
        .navigationTitle("My Pets")
        .searchable(text: $viewModel.searchText, prompt: "Search pets")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    appCoordinator.showAddPet()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
            }
        }
    }

    private var petList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredPets) { pet in
                    PetCardView(pet: pet) {
                        viewModel.selectPet(pet)
                    } onSpinWheel: {
                        appCoordinator.showWheel(for: pet)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

struct EmptyPetsView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "pawprint.circle")
                .font(.system(size: 80))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text("No Pets Yet")
                    .font(.title2.weight(.semibold))
                Text("Add your first pet to get started!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button("Add a Pet") {
                appCoordinator.showAddPet()
            }
            .primaryButtonStyle()
            .frame(maxWidth: 200)
        }
        .padding(32)
    }
}
