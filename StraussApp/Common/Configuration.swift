import Foundation

enum Configuration {

    private enum Keys {
        static let baseURL = "BASE_URL"
    }

    static let baseURL: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: Keys.baseURL) as? String
        else { fatalError("\(Keys.baseURL) not found") }
        return key
    }()
}
