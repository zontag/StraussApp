import Foundation
import UIKit

final class SearchCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var didFinish: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        else { return }

        let store = StraussAppStore(container: container)
        let api = iTunesAPI()
        let musicTrackRepository = MusicTrackRepository(api: api, storage: store)
        let searchStraussTracks = SearchStraussTracks(repository: musicTrackRepository)
        let viewModel = SearchResultViewModel(searchTracks: searchStraussTracks)

        let vc = SearchResultViewController(viewModel: viewModel) { [weak self] vc in
            self?.viewControllerDidDisapear(vc)
        } didSelect: { [weak self] track in
            self?.showDetail(item: track)
        }

        navigationController.pushViewController(vc, animated: false)
    }

    private func viewControllerDidDisapear(_ vc: UIViewController) {
        if navigationController.viewControllers.contains(vc) { return }
        didFinish?()
    }

    private func showDetail(item: MusicTrack) {
        let child = TrackDetailCoordinator(navigationController: navigationController, item: item)
        child.didFinish = { [weak self] in self?.childDidFinish(child) }
        childCoordinators.append(child)
        child.start()
    }
}
