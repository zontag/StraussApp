import Foundation
import UIKit

final class SceneCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var didFinish: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let child = SearchCoordinator(navigationController: navigationController)
        child.didFinish = { [weak self] in self?.childDidFinish(child) }
        childCoordinators.append(child)
        child.start()
    }
}
