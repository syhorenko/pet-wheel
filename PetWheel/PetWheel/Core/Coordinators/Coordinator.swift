import Foundation

protocol Coordinator: AnyObject, ObservableObject {
    associatedtype Route
    func navigate(to route: Route)
}
