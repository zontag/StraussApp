import Foundation
@testable import StraussApp

final class MockAPI: API, DataProvider {

    var tracksJsonFileName = ""

    var tracksFailure: Error?

    func search(terms: [String], entity: StraussApp.SearchEntity) async throws -> StraussApp.SearchResponse {
        if let tracksFailure { throw tracksFailure }
        let data = try getData(fromJSON: tracksJsonFileName)
        return decode(data)
    }

    func reset() {
        tracksJsonFileName = ""
        tracksFailure = nil
    }

    private func decode<T: Decodable>(_ data: Data) -> T {
        try! JSONDecoder().decode(T.self, from: data)
    }
}
