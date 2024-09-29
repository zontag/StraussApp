import Foundation
import UIKit

extension UIImageView {

    func load(url: URL) {
        Task(priority: .userInitiated) {
            let image = await ImageCache.shared.getImage(for: url)
            self.image = image
        }
    }
}
