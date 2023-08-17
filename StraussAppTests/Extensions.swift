import Foundation
import XCTest

enum TestError: Error {
    case fileNotFound
}

protocol DataProvider: AnyObject {
    func getData(fromJSON fileName: String) throws -> Data
}

extension DataProvider {

    func getData(fromJSON fileName: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("Missing File: \(fileName).json")
            throw TestError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw error
        }
    }
}
