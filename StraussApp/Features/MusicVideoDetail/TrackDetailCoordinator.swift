import Foundation
import UIKit

final class TrackDetailCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var didFinish: (() -> Void)?
    var item: MusicTrack

    init(navigationController: UINavigationController, item: MusicTrack) {
        self.navigationController = navigationController
        self.item = item
    }

    func start() {
        let viewModel = TrackDetailViewModel(item: item)
        let vc = TrackDetailViewController(viewModel: viewModel) { [weak self] vc in
            self?.trackDetailDidDisapear(vc)
        }
        navigationController.pushViewController(vc, animated: true)
    }

    private func trackDetailDidDisapear(_ vc: UIViewController) {
        if navigationController.viewControllers.contains(vc) { return }
        didFinish?()
    }
}
