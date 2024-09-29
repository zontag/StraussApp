import Foundation

enum SearchEntity: String {
    case musicVideo
    case musicTrack
}

protocol API {
    func search(terms: [String], entity: SearchEntity) async throws -> SearchResponse
}

enum APIFailure: Error {
    case invalidResponse
    case invalidStatusCode
    case invalidURL
    case decodingFailure
    case invalidToken
}

final class iTunesAPI: API, Loging {

    var urlSession = URLSession.shared
    var provider = Configuration.baseURL

    func search(terms: [String], entity: SearchEntity) async throws -> SearchResponse {
        let baseURL = try url(path: "/search")
        var comp = URLComponents(string: baseURL.absoluteString)

        comp?.queryItems = [
            URLQueryItem(name: "term", value: terms.joined(separator: "+")),
            URLQueryItem(name: "entity", value: entity.rawValue)
        ]
        
        guard let finalURL = comp?.url else {
            throw APIFailure.invalidURL
        }
        return try await request(url: finalURL)
    }

    // MARK: Private

    private func request<T: Decodable>(url: URL) async throws -> T {

        let request = URLRequest(url: url)

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response.http else {
            throw APIFailure.invalidResponse
        }

        guard httpResponse.isSuccessful else {
            throw APIFailure.invalidStatusCode
        }

        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            log(error)
            throw APIFailure.decodingFailure
        }
    }

    private func url(path: String) throws -> URL {

        guard var component = URLComponents(string: provider) else {
            throw APIFailure.invalidURL
        }

        component.path = path

        guard let url = component.url else {
            throw APIFailure.invalidURL
        }

        return url
    }
}
