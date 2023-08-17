import Foundation
import UIKit

@MainActor
final class TrackDetailViewController: UIViewController {

    // MARK: Private properties
    private let viewModel: TrackDetailViewModel
    private let didDisappear: ((TrackDetailViewController) -> Void)?
    private let contentView = TrackDetailView()

    // MARK: Init
    init(viewModel: TrackDetailViewModel,
         didDisappear: ((TrackDetailViewController) -> Void)?) {
        self.viewModel = viewModel
        self.didDisappear = didDisappear
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.trackName
        contentView.trackName = viewModel.trackName
        contentView.artistName = viewModel.artistName
        contentView.collectionName = viewModel.collectionName
        contentView.collectionPrice = viewModel.price
        contentView.previewURL = viewModel.previewURL
        if let url = viewModel.image {
            contentView.image(url: url)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappear?(self)
    }
}
