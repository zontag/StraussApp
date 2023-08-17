//
//  CoinAPITests.swift
//  CoinAPITests
//
//  Created by WK on 15/06/2023.
//

import XCTest
@testable import StraussApp

final class iTunesAPITests: XCTestCase, DataProvider {

    var api: iTunesAPI!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        api = iTunesAPI()
        api.urlSession = urlSession
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPITracksSuccessfulResponse() async throws {

        // Given
        let data = try getData(fromJSON: "Tracks")
        let tracksURL = try XCTUnwrap(URL(string: "https://itunes.apple.com/search?term=richard+strauss&entity=musicTrack&attribute=composerTerm"))
        let terms = ["richard", "strauss"]

        MockURLProtocol.requestHandler = { request in
            guard let url = request.url,
                  url.path == tracksURL.path,
                  url.host == tracksURL.host
            else {
                throw APIFailure.invalidURL
            }

            let response = HTTPURLResponse(url: tracksURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        // When
        let list = try await api.search(terms: terms, entity: .musicTrack)

        // Then
        XCTAssertEqual(list.resultCount, 50)
        XCTAssertFalse(list.results!.isEmpty)
        XCTAssertEqual(list.results!.first?.artistId, 19914792)
    }

    func testAPITracksParsingFailure() async throws {

        // Given
        let data = Data()
        let tracksURL = try XCTUnwrap(URL(string: "https://itunes.apple.com/search?term=richard+strauss&entity=musicTrack&attribute=composerTerm"))
        let terms = ["richard", "strauss"]

        MockURLProtocol.requestHandler = { request in
            guard let url = request.url,
                  url.path == tracksURL.path,
                  url.host == tracksURL.host
            else {
                throw APIFailure.invalidURL
            }

            let response = HTTPURLResponse(url: tracksURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        // When
        do {
            _ = try await api.search(terms: terms, entity: .musicTrack)
        } catch {
            // Then
            if let failure = error as? APIFailure, failure == APIFailure.decodingFailure {
                XCTAssertTrue(true)
            } else {
                XCTAssertTrue(false)
            }
        }
    }

    func testAPITracksStatusCodeFailure() async throws {

        // Given
        let data = Data()
        let tracksURL = try XCTUnwrap(URL(string: "https://itunes.apple.com/search?term=richard+strauss&entity=musicTrack&attribute=composerTerm"))
        let terms = ["richard", "strauss"]

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: tracksURL, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        // When
        do {
            _ = try await api.search(terms: terms, entity: .musicTrack)
        } catch {
            // Then
            if let failure = error as? APIFailure, failure == APIFailure.invalidStatusCode {
                XCTAssertTrue(true)
            } else {
                XCTAssertTrue(false)
            }
        }
    }
}
