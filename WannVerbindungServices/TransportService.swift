//
//  TransportRestService.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 14.10.22.
//

import Foundation

public class TransportService {
    private static let host: String = "https://v5.db.transport.rest"

    private static func getUrlRequest(
        forEndpoint endpoint: String,
        withQueryItems queryItems: [URLQueryItem] = []
    ) -> URLRequest {
        var urlComponents = URLComponents(string: "\(Self.host)/\(endpoint)")!
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        return .init(url: urlComponents.url!)
    }

    public init() {}

    public func getJourney(from: Int, to: Int) async throws -> Journey {
        let urlRequest = Self.getUrlRequest(
            forEndpoint: "journey",
            withQueryItems: [
                .init(name: "from", value: "\(from)"),
                .init(name: "to", value: "\(to)"),
                .init(name: "transfers", value: "0"),
                .init(name: "results", value: "3"),
            ]
        )

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let journey = try JSONDecoder().decode(Journey.self, from: data)

        return journey
    }

    public func getStops(forQuery query: String) async throws -> [Stop] {
        let urlRequest = Self.getUrlRequest(
            forEndpoint: "journey",
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

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let stops = try JSONDecoder().decode([Stop].self, from: data)

        return stops
    }
}
