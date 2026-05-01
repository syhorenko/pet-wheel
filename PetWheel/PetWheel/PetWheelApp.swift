import SwiftUI

@main
struct PetWheelApp: App {
    @StateObject private var appCoordinator = AppCoordinator()

    init() {
        configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: appCoordinator)
                .preferredColorScheme(.dark)
        }
    }

    private func configureAppearance() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.08, alpha: 1)
        navAppearance.shadowColor = nil
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = UIColor(red: 0.49, green: 0.23, blue: 0.93, alpha: 1)

        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(red: 0.07, green: 0.07, blue: 0.11, alpha: 1)
        tabAppearance.shadowColor = nil
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().tintColor = UIColor(red: 0.49, green: 0.23, blue: 0.93, alpha: 1)
    }
}
