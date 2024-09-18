//
//  ExampleCodableValue.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

import Foundation


class EmptyEncoder: JSONEncoder, @unchecked Sendable {
    override func encode<T: Encodable>(_ value: T) throws -> Data {
        return Data()
    }
}

struct ExampleCodableValue: Codable, Equatable {
    let title: String
    let description: String
}
