//
//  Station.swift
//  WannVerbindungServices
//
//  Created by Florian Rhein on 14.10.22.
//

import Foundation

public struct Stop: Codable {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
