//
//  TransportRestService.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 14.10.22.
//

import Foundation

public class TransportService {
    public enum HttpError: Error {
        case invalidResponse(statusCode: Int)
    }

    private static let host: String = "https://v5.db.transport.rest"

    private static func getUrlRequest(
        forEndpoint endpoint: String,
        withQueryItems queryItems: [URLQueryItem]
    ) -> URLRequest {
        var urlComponents = URLComponents(string: "\(Self.host)/\(endpoint)")!
        urlComponents.queryItems = queryItems

        return URLRequest(url: urlComponents.url!)
    }

    private var jsonDecoder: JSONDecoder

    public init() {
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }

    public func getJourneys(from: Int, to: Int) async throws -> JourneySearchResult {
        let urlRequest = Self.getUrlRequest(
            forEndpoint: "journeys",
            withQueryItems: [
                .init(name: "from", value: "\(from)"),
                .init(name: "to", value: "\(to)"),
                .init(name: "departure", value: "now"),
                .init(name: "transfers", value: "0"),
                .init(name: "results", value: "3"),
            ]
        )

        let data = try await self.handleUrlRequest(urlRequest)
        let journeySearchResult = try self.jsonDecoder.decode(JourneySearchResult.self, from: data)

        return journeySearchResult
    }

    public func getStops(forQuery query: String) async throws -> [Stop] {
        let urlRequest = Self.getUrlRequest(
            forEndpoint: "localtions",
            withQueryItems: [
                .init(name: "query", value: query),
                .init(name: "fuzzy", value: "false"),
                .init(name: "results", value: "3"),
                .init(name: "stops", value: "true"),
                .init(name: "addresses", value: "false"),
                .init(name: "poi", value: "false"),
                .init(name: "linesOfStops", value: "false"),
            ]
        )

        let data = try await self.handleUrlRequest(urlRequest)
        let stops = try JSONDecoder().decode([Stop].self, from: data)

        return stops
    }

    private func handleUrlRequest(_ urlRequest: URLRequest) async throws -> Data {
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)

        if let httpResponse = urlResponse as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                guard let apiError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                    throw HttpError.invalidResponse(statusCode: httpResponse.statusCode)
                }

                throw apiError
            }
        }

        return data
    }
}
