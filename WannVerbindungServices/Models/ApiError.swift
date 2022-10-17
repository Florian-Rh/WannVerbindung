//
//  ApiError.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 17.10.22.
//

import Foundation

public struct ApiError: LocalizedError, Decodable {
    public let isHafasError: Bool?
    public let transportRestErrorMessage: String?
    public let internalErrorMessage: String
    public let hafasErrorMessage: String?

    public var localizedDescription: String {
        self.hafasErrorMessage ?? self.transportRestErrorMessage ?? self.internalErrorMessage
    }

    internal enum CodingKeys: String, CodingKey {
        case isHafasError
        case transportRestErrorMessage = "message"
        case internalErrorMessage = "msg"
        case hafasErrorMessage
    }
}
