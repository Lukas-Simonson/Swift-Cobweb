//
//  URL.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

import Foundation

public extension Cobweb {
    
    /// Represents a network URL.
    ///
    /// This class encapsulates the components of a URL and provides methods to manipulate the URL components.
    final class URL {
        
        /// The URL components.
        internal private(set) var components: URLComponents
        
        /// Initializes a new `URL` instance with the specified URL components.
        ///
        /// - Parameter comp: The URL components.
        internal init(comp: URLComponents) {
            self.components = comp
            if components.scheme == nil { components.scheme = Cobweb.HTTP.Scheme.https.rawValue }
        }
        
        enum URLError: Error {
            case couldntCreateURL
        }
    }
}

// MARK: - Creator Functions
public extension Cobweb.URL {
    
    /// Creates a new `Cobweb.URL` instance with the specified URL components.
    ///
    /// This method creates a new `Cobweb.URL` instance with the provided URL components.
    ///
    /// - Parameter components: The URL components.
    /// - Returns: A new `Cobweb.URL` instance with the specified URL components.
    static func using(components: URLComponents) -> Self {
        return Self(comp: components)
    }
    
    /// Creates a new `Cobweb.URL` instance with the specified scheme.
    ///
    /// This method creates a new `Cobweb.URL` instance with the provided scheme.
    ///
    /// - Parameter scheme: The scheme to set for the URL.
    /// - Returns: A new `Cobweb.URL` instance with the specified scheme.
    static func scheme(_ scheme: Cobweb.HTTP.Scheme) -> Self {
        return Self.scheme(scheme.rawValue)
    }
    
    /// Creates a new `Cobweb.URL` instance with the specified scheme.
    ///
    /// This method creates a new `Cobweb.URL` instance with the provided scheme.
    ///
    /// - Parameter string: The string representation of the scheme to set for the URL.
    /// - Returns: A new `Cobweb.URL` instance with the specified scheme.
    static func scheme(_ string: String) -> Self {
        let url = Self(comp: URLComponents())
        url.components.scheme = string
        return url
    }
    
    /// Creates a new `Cobweb.URL` instance with the specified host.
    ///
    /// This method creates a new `Cobweb.URL` instance with the provided host.
    ///
    /// - Parameter string: The string representation of the host to set for the URL.
    /// - Returns: A new `Cobweb.URL` instance with the specified host.
    static func host(_ string: String) -> Self {
        let url = Self(comp: URLComponents())
        url.components.host = string
        return url
    }
}

// MARK: - Builder Functions
public extension Cobweb.URL {
    /// Sets the scheme of the URL.
    ///
    /// This method sets the scheme of the URL to the specified scheme.
    ///
    /// - Parameter scheme: The scheme to set for the URL.
    /// - Returns: The modified `Cobweb.URL` instance with the specified scheme.
    func scheme(_ scheme: Cobweb.HTTP.Scheme) -> Self {
        self.components.scheme = scheme.rawValue
        return self
    }
    
    /// Sets the scheme of the URL.
    ///
    /// This method sets the scheme of the URL to the specified scheme.
    ///
    /// - Parameter string: The string representation of the scheme to set for the URL.
    /// - Returns: The modified `Cobweb.URL` instance with the specified scheme.
    func scheme(_ string: String) -> Self {
        self.components.scheme = string
        return self
    }
    
    /// Sets the host of the URL.
    ///
    /// This method sets the host of the URL to the specified host.
    ///
    /// - Parameter string: The string representation of the host to set for the URL.
    /// - Returns: The modified `Cobweb.URL` instance with the specified host.
    func host(_ string: String) -> Self {
        self.components.host = string
        return self
    }
    
    /// Sets the path of the URL.
    ///
    /// This method sets the path of the URL to the specified path.
    ///
    /// - Parameter string: The string representation of the path to set for the URL.
    /// - Returns: The modified `Cobweb.URL` instance with the specified path.
    func path(_ string: String) -> Self {
        self.components.path = string
        return self
    }
    
    /// Sets the query of the URL.
    ///
    /// This method sets the query of the URL to the specified query.
    ///
    /// - Parameter string: The string representation of the query to set for the URL.
    /// - Returns: The modified `Cobweb.URL` instance with the specified query.
    func query(_ string: String) -> Self {
        self.components.query = string
        return self
    }
    
    /// Sets the port of the URL.
    ///
    /// This method sets the port of the URL to the specified port number.
    ///
    /// - Parameter number: The port number to set for the URL.
    /// - Returns: The modified `Cobweb.URL` instance with the specified port.
    func port(_ number: Int) -> Self {
        self.components.port = number
        return self
    }
    
    /// Sets the fragment of the URL.
    ///
    /// This method sets the fragment of the URL to the specified fragment.
    ///
    /// - Parameter string: The string representation of the fragment to set for the URL.
    /// - Returns: The modified `Cobweb.URL` instance with the specified fragment.
    func fragment(_ string: String) -> Self {
        self.components.fragment = string
        return self
    }
}

// MARK: - HTTP.Request Functions
public extension Cobweb.URL {
    
    /// Creates a network request with the specified HTTP method.
    ///
    /// This method creates a network request with the specified HTTP method using the `Cobweb.URL`. It throws an error if the URL cannot be created.
    ///
    /// - Parameter method: The HTTP method for the request.
    /// - Returns: A network request configured with the specified HTTP method and URL.
    /// - Throws: `Cobweb.URL.URLError.couldntCreateURL` if the URL cannot be created.
    func request(method: Cobweb.HTTP.Method) throws -> Cobweb.HTTP.Request {
        guard let url = self.components.url
        else { throw Cobweb.URL.URLError.couldntCreateURL }
        
        return Cobweb.HTTP.Request.method(method, url)
    }
    
    /// Creates a GET request.
    ///
    /// This method creates a GET request using the `Cobweb.URL`. It throws an error if the URL cannot be created.
    ///
    /// - Returns: A GET request configured with the URL.
    /// - Throws: `Cobweb.URL.URLError.couldntCreateURL` if the URL cannot be created.
    func get() throws -> Cobweb.HTTP.Request {
        try self.request(method: .get)
    }
    
    /// Creates a POST request.
    ///
    /// This method creates a POST request using the `Cobweb.URL`. It throws an error if the URL cannot be created.
    ///
    /// - Returns: A POST request configured with the URL.
    /// - Throws: `Cobweb.URL.URLError.couldntCreateURL` if the URL cannot be created.
    func post() throws -> Cobweb.HTTP.Request {
        try self.request(method: .post)
    }
    
    /// Creates a PUT request.
    ///
    /// This method creates a PUT request using the `Cobweb.URL`. It throws an error if the URL cannot be created.
    ///
    /// - Returns: A PUT request configured with the URL.
    /// - Throws: `Cobweb.URL.URLError.couldntCreateURL` if the URL cannot be created.
    func put() throws -> Cobweb.HTTP.Request {
        try self.request(method: .put)
    }
    
    /// Creates a DELETE request.
    ///
    /// This method creates a DELETE request using the `Cobweb.URL`. It throws an error if the URL cannot be created.
    ///
    /// - Returns: A DELETE request configured with the URL.
    /// - Throws: `Cobweb.URL.URLError.couldntCreateURL` if the URL cannot be created.
    func delete() throws -> Cobweb.HTTP.Request {
        try self.request(method: .delete)
    }
}

// MARK: - WebSocket.Request Functions
public extension Cobweb.URL {
    
    /// Creates a network request for a WebSocket connection.
    ///
    /// This method creates a network request for a `Cobweb.WebSocket.Connection` using the `Cobweb.URL`. It throws an error if the URL cannot be created.
    ///
    /// - Returns: A network request configured for the WebSocket connection.
    /// - Throws: `Cobweb.URL.URLError.couldntCreateURL` if the URL cannot be created.
    func webSocket() throws -> Cobweb.WebSocket.Request {
        guard let url = self.components.url
        else { throw Cobweb.URL.URLError.couldntCreateURL }
        
        return Cobweb.WebSocket.Request(URLRequest(url: url))
    }
}
