import Foundation
import UIKit
import AVFoundation

final class TrackDetailView: UIView {

    // MARK: Public properties

    var trackName: String? {
        get {
            trackNameLabel.text
        }
        set {
            trackNameLabel.text = newValue
        }
    }

    var artistName: String? {
        get {
            artistNameLabel.text
        }
        set {
            artistNameLabel.text = newValue
        }
    }

    var collectionName: String? {
        get {
            collectionNameLabel.text
        }
        set {
            collectionNameLabel.text = newValue
        }
    }

    var collectionPrice: String? {
        get {
            collectionPriceLabel.text
        }
        set {
            collectionPriceLabel.text = newValue
        }
    }

    var previewURL: URL?

    // MARK: Private properties

    private var player: AVPlayer?

    private var isPlaying: Bool = false {
        didSet {
            setupPlayerState()
        }
    }

    private var timeObserverToken: Any?

    // MARK: Private methods

    private func createPlayer() async {
        guard let previewURL else { return }
        let asset = AVAsset(url: previewURL)
        let playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.actionAtItemEnd = .pause

        let interval = CMTimeMultiplyByFloat64(asset.duration, multiplier: 0.99)


        timeObserverToken = self.player?.addBoundaryTimeObserver(
            forTimes: [
                NSValue(time: interval)
                //NSValue(time: playerItem.duration)
            ],
            queue: DispatchQueue.main,
            using: { [weak self] in
                self?.isPlaying.toggle()
            })
    }

    private func setupPlayerState() {
        let btnTitle = isPlaying ? "Stop" : "Play"
        previewButton.setTitle(btnTitle, for: .normal)

        if self.isPlaying {
            var createPlayerToken = Task(priority: .userInitiated) {
                await createPlayer()
                await MainActor.run {
                    self.player?.play()
                }
            }
        } else {
            self.stopPlayer()
        }
    }

    private func stopPlayer() {
        self.player?.pause()
        self.player = nil
    }

    // MARK: Views

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var trackNameTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Track"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var artistNameTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Artist"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var collectionNameTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Collection"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var collectionPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Price"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    private lazy var collectionPriceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private var line: UIView {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }

    private lazy var previewButton: UIButton = {
        let btn = UIButton(type: .roundedRect, primaryAction: .init(title: "Play", handler: { [weak self] _ in
            guard let self else { return }
            self.isPlaying.toggle()
        }))
        return btn
    }()

    private lazy var vStack: UIStackView = {
        let line1 = line

        let stack = UIStackView(arrangedSubviews: [
            imageView,
            previewButton,
            line1,
            trackNameTitleLabel,
            trackNameLabel,
            artistNameTitleLabel,
            artistNameLabel,
            collectionNameTitleLabel,
            collectionNameLabel,
            collectionPriceTitleLabel,
            collectionPriceLabel,
            UIView()])

        stack.setCustomSpacing(8, after: imageView)
        stack.setCustomSpacing(32, after: previewButton)
        stack.setCustomSpacing(32, after: line1)
        stack.setCustomSpacing(16, after: trackNameLabel)
        stack.setCustomSpacing(16, after: artistNameLabel)
        stack.setCustomSpacing(16, after: collectionNameLabel)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()

    // MARK: Init

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.systemBackground
        addSubviews()
        makeConstraints()
    }

    deinit {
        if let timeObserverToken {
            self.player?.removeTimeObserver(timeObserverToken)
        }
        self.player?.pause()
        self.player = nil
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func image(url: URL) {
        self.imageView.load(url: url)
    }

    private func addSubviews() {
        addSubview(vStack)
    }

    private func makeConstraints() {
        // vStack
        vStack.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32)
            .isActive = true

        vStack.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -32)
            .isActive = true

        vStack.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 32)
            .isActive = true

        vStack.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -32)
            .isActive = true

        // imageView

        imageView.heightAnchor
            .constraint(equalToConstant: 100)
            .isActive = true
    }
}
