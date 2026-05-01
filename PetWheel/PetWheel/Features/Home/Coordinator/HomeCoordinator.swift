import SwiftUI

enum HomeRoute: Hashable {
    case petDetail(Pet)
}

final class HomeCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()

    let petService: PetService

    init(petService: PetService) {
        self.petService = petService
    }

    func navigateToPetDetail(_ pet: Pet) {
        navigationPath.append(HomeRoute.petDetail(pet))
    }

    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}

struct HomeCoordinatorView: View {
    @ObservedObject var coordinator: HomeCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            HomeView(viewModel: HomeViewModel(petService: coordinator.petService, coordinator: coordinator))
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .petDetail(let pet):
                        PetDetailView(
                            viewModel: PetDetailViewModel(
                                pet: pet,
                                petService: coordinator.petService
                            )
                        )
                    }
                }
        }
    }
}
