import UIKit

@MainActor
final class SearchResultViewController<SomeSearchStraussTracks: SearchStraussTracksUseCase>: UICollectionViewController {

    // MARK: Typealias

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MusicTrack>
    private typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MusicTrack>

    // MARK: Private properties

    private var viewModel: SearchResultViewModel<SomeSearchStraussTracks>
    private var didDisappear: ((SearchResultViewController) -> Void)?
    private var didSelect: ((MusicTrack) -> Void)?
    private var cellRegistration: CellRegistration?
    private let refreshControl = UIRefreshControl()
    private let accentColor = #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1)

    private lazy var dataSource = DataSource(collectionView: collectionView)
    { [weak self] in self?.provideCell($0, $1, $2) }

    // MARK: Init

    init(viewModel: SearchResultViewModel<SomeSearchStraussTracks>,
         didDisappear: ((SearchResultViewController) -> Void)? = nil,
         didSelect: ((MusicTrack) -> Void)? = nil) {
        self.viewModel = viewModel
        self.didDisappear = didDisappear
        self.didSelect = didSelect
        super.init(collectionViewLayout: Self.layout())

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        configCollectionView()
        registerRefreshControl()
        registerCell()

        viewModel.onItemsChanged = { [weak self] in
            self?.applySnapshot()
            self?.refreshControl.endRefreshing()
        }

        viewModel.onError = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.showAlert()
        }

        // Start initial data fetch
        viewModel.search()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappear?(self)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("did selected item at row \(indexPath.row)")
        collectionView.deselectItem(at: indexPath, animated: true)
        if let item = viewModel.track(for: indexPath.row) {
            didSelect?(item)
        }
    }

    @objc
    func didPullToRefresh(_ sender: Any) {
        viewModel.search()
    }
}

// MARK: - Private
private extension SearchResultViewController {

    func configCollectionView() {
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
    }

    func registerRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }

    func registerCell() {
        cellRegistration = CellRegistration { [weak self] cell, indexPath, track in
            guard let self = self else { return }
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = self.viewModel.trackName(for: indexPath.row)
            contentConfig.secondaryText = self.viewModel.artistName(for: indexPath.row)
            contentConfig.secondaryTextProperties.color = .secondaryLabel
            contentConfig.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            cell.accessories = [.disclosureIndicator()]
            cell.contentConfiguration = contentConfig
        }
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MusicTrack>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func provideCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ track: MusicTrack
    ) -> UICollectionViewCell? {

        guard let cellRegistration = self.cellRegistration else { return nil }
        return collectionView.dequeueConfiguredReusableCell(
            using: cellRegistration,
            for: indexPath,
            item: track)
    }

    func showAlert() {
        let dialogMessage = UIAlertController(title: "Error", message: "Unable to update list", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(okAction)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

// MARK: - Private Static
private extension SearchResultViewController {
    static func layout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = UIColor.accent
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

// MARK: - Inner types
private extension SearchResultViewController {
    enum Section: CaseIterable {
        case main
    }
}
