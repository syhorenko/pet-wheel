import SwiftUI

enum AppRoute: Hashable {
    case home
    case petDetail(Pet)
    case addPet
    case wheel(Pet)
}

final class AppCoordinator: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var presentedSheet: AppSheet?

    let homeCoordinator: HomeCoordinator
    let petService: PetService

    init() {
        let service = PetService.shared
        self.petService = service
        self.homeCoordinator = HomeCoordinator(petService: service)
    }

    func showAddPet() {
        presentedSheet = .addPet
    }

    func showWheel(for pet: Pet) {
        presentedSheet = .wheel(pet)
    }

    func dismissSheet() {
        presentedSheet = nil
    }
}

enum AppTab: Int, CaseIterable {
    case home
    case wheel

    var title: String {
        switch self {
        case .home: return "My Pets"
        case .wheel: return "Wheel"
        }
    }

    var icon: String {
        switch self {
        case .home: return "pawprint.fill"
        case .wheel: return "circle.grid.2x2.fill"
        }
    }
}

enum AppSheet: Identifiable {
    case addPet
    case wheel(Pet)

    var id: String {
        switch self {
        case .addPet: return "addPet"
        case .wheel(let pet): return "wheel-\(pet.id)"
        }
    }
}

struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            HomeCoordinatorView(coordinator: coordinator.homeCoordinator)
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.icon)
                }
                .tag(AppTab.home)

            WheelTabView(coordinator: coordinator)
                .tabItem {
                    Label(AppTab.wheel.title, systemImage: AppTab.wheel.icon)
                }
                .tag(AppTab.wheel)
        }
        .environmentObject(coordinator)
        .sheet(item: $coordinator.presentedSheet) { sheet in
            switch sheet {
            case .addPet:
                AddPetCoordinatorView(
                    coordinator: AddPetCoordinator(petService: coordinator.petService),
                    onDismiss: { coordinator.dismissSheet() }
                )
            case .wheel(let pet):
                WheelCoordinatorView(
                    coordinator: WheelCoordinator(pet: pet, petService: coordinator.petService),
                    onDismiss: { coordinator.dismissSheet() }
                )
            }
        }
    }
}
