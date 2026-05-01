import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            Group {
                if viewModel.pets.isEmpty {
                    EmptyPetsView()
                } else {
                    petList
                }
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
                        .foregroundStyle(Color.neonPurple)
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
        VStack(spacing: 28) {
            ZStack {
                Circle()
                    .fill(Color.neonPurple.opacity(0.10))
                    .frame(width: 120, height: 120)
                Circle()
                    .strokeBorder(Color.neonPurple.opacity(0.25), lineWidth: 1)
                    .frame(width: 120, height: 120)
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.neonPurple.opacity(0.7))
            }

            VStack(spacing: 8) {
                Text("No Pets Yet")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                Text("Add your first pet to get started!")
                    .font(.subheadline)
                    .foregroundStyle(Color.mutedText)
                    .multilineTextAlignment(.center)
            }

            Button("Add a Pet") {
                appCoordinator.showAddPet()
            }
            .primaryButtonStyle()
            .frame(maxWidth: 220)
        }
        .padding(32)
    }
}
