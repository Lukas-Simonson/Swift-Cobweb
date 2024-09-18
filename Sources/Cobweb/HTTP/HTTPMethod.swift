//
//  HTTPMethod.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

public extension Cobweb.HTTP {
    
    /// Represents the different HTTP method types.
    ///
    /// This enum defines various HTTP methods as specified by RFC 7231 and other relevant RFCs.
    enum Method: String, CaseIterable, Sendable {
        /// The GET method.
        case get = "GET"
        
        /// The HEAD method.
        case head = "HEAD"
        
        /// The POST method.
        case post = "POST"
        
        /// The PUT method.
        case put = "PUT"
        
        /// The DELETE method.
        case delete = "DELETE"
        
        /// The CONNECT method.
        case connect = "CONNECT"
        
        /// The OPTIONS method.
        case options = "OPTIONS"
        
        /// The TRACE method.
        case trace = "TRACE"
        
        /// The PATCH method.
        case patch = "PATCH"
        
        /// The name of the HTTP method.
        ///
        /// This property returns the raw value of the enum case, which is the HTTP method name as a string.
        public var name: String { self.rawValue }
    }
}
