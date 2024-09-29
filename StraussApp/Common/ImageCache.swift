import Foundation
import UIKit

actor ImageCache {

    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func getImage(for url: URL) async -> UIImage? {

        if let image = cache.object(forKey: url.absoluteString as NSString) {
            return image
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }
            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            return image
        } catch {
            return nil
        }
    }
}
