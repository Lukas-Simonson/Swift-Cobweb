//
//  WSRequest.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

import Foundation

public extension Cobweb.WebSocket {
    final class Request {
        internal private(set) var request: URLRequest
        internal private(set) var session: URLSession = .shared
        
        internal init(_ request: URLRequest) {
            self.request = request
        }
        
        enum RequestError: Error {
            case invalidURLString
        }
    }
}

// MARK: - Creation Functions
public extension Cobweb.WebSocket.Request {
    static func create(_ url: URL) -> Self {
        Self(URLRequest(url: url))
    }
    
    static func create(_ string: String) throws -> Self {
        guard let url = URL(string: string)
        else { throw RequestError.invalidURLString }
        return Self(URLRequest(url: url))
    }
}

// MARK: - Connection Functions
public extension Cobweb.WebSocket.Request {
    func connection() -> Cobweb.WebSocket.Connection {
        Cobweb.WebSocket.Connection(request: self)
    }
}
