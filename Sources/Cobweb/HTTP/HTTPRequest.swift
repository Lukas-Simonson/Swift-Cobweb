//
//  HTTPRequest.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

import Foundation

public extension Cobweb.HTTP {
    
    /// `Request` is used to represent a full HTTP network request. This contains information such as the headers, http method, etc.
    final class Request {
        
        /// The internal request that backs up this `Cobweb.HTTP.Request`.
        internal private(set) var request: URLRequest
        
        /// The internal `URLSession` this `Cobweb.HTTP.Request` should use when making the request.
        internal private(set) var session: URLSession = .shared
        
        /// Creates a `Cobweb.HTTP.Request` using a `URLRequest`.
        internal init(_ request: URLRequest) {
            self.request = request
        }
        
        enum RequestError: Error {
            case invalidURLString
        }
    }
}

// MARK: - Creation Functions
public extension Cobweb.HTTP.Request {
    
    /// Validates a string to ensure it is a properly formatted URL.
    ///
    /// This method attempts to create a `URL` object from the provided string. If the string is not a valid URL, it throws an error.
    ///
    /// - Parameter str: The string to validate as a URL.
    /// - Returns: A valid `URL` object if the string is properly formatted.
    /// - Throws: `Cobweb.HTTP.RequestError.invalidURLString` if the string cannot be converted to a valid URL.
    ///
    /// - Note: This method is static and private, intended for internal use within the `Cobweb.HTTP.Request` class.
    private static func validateURLString(_ str: String) throws -> URL {
        guard let url = URL(string: str)
        else { throw RequestError.invalidURLString }
        return url
    }
    
    /// Creates an instance configured with the specified HTTP method and URL string.
    ///
    /// This method validates the provided URL string then generates a `Cobweb.HTTP.Request` object configured with the provided HTTP method and URL, then returns an instance initialized with this request.
    ///
    /// - Parameters:
    ///   - method: The HTTP method to use for the request. This should be one of the cases from `Network.HTTP.Method`.
    ///   - urlString: The string representation of the URL for the request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the specified HTTP method and URL.
    static func method(_ method: Cobweb.HTTP.Method, _ urlString: String) throws -> Self {
        return try Self.method(method, validateURLString(urlString))
    }
    
    /// Creates an instance configured with the specified HTTP method and URL.
    ///
    /// This method generates a `Cobweb.HTTP.Request` object configured with the provided HTTP method and URL, then returns an instance initialized with this request.
    ///
    /// - Parameters:
    ///   - method: The HTTP method to use for the request. This should be one of the cases from `Network.HTTP.Method`.
    ///   - url: The URL for the request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the specified HTTP method and URL.
    static func method(_ method: Cobweb.HTTP.Method, _ url: URL) -> Self {
        var request = URLRequest(url: url)
        request.httpMethod = method.name
        return Self(request)
    }
    
    /// Creates a `Cobweb.HTTP.Request` instance configured with a GET request for the specified URL string.
    ///
    /// This method validates the provided URL string and then generates a `Cobweb.HTTP.Request` object configured with the GET method, returning an instance initialized with this request.
    ///
    /// - Parameter urlString: The string representation of the URL for the GET request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the GET method and the specified URL.
    /// - Throws: `Cobweb.HTTP.RequestError.invalidURLString` if the URL string is not valid.
    static func get(_ urlString: String) throws -> Self {
        return try Self.get(validateURLString(urlString))
    }
    
    /// Creates a `Cobweb.HTTP.Request` configured with a GET request for the specified URL.
    ///
    /// This method generates a `Cobweb.HTTP.Request` object configured with the GET method and the provided URL, returning an instance initialized with this request.
    ///
    /// - Parameter url: The URL for the GET request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the GET method and the specified URL.
    static func get(_ url: URL) -> Self {
        Self.method(.get, url)
    }
    
    /// Creates a `Cobweb.HTTP.Request` instance configured with a POST request for the specified URL string.
    ///
    /// This method validates the provided URL string and then generates a `Cobweb.HTTP.Request` object configured with the POST method, returning an instance initialized with this request.
    ///
    /// - Parameter urlString: The string representation of the URL for the POST request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the POST method and the specified URL.
    /// - Throws: `Cobweb.HTTP.RequestError.invalidURLString` if the URL string is not valid.
    static func post(_ urlString: String) throws -> Self {
        try Self.post(validateURLString(urlString))
    }
    
    /// Creates a `Cobweb.HTTP.Request` configured with a POST request for the specified URL.
    ///
    /// This method generates a `Cobweb.HTTP.Request` object configured with the POST method and the provided URL, returning an instance initialized with this request.
    ///
    /// - Parameter url: The URL for the GET request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the POST method and the specified URL.
    static func post(_ url: URL) -> Self {
        Self.method(.post, url)
    }
    
    /// Creates a `Cobweb.HTTP.Request` instance configured with a PUT request for the specified URL string.
    ///
    /// This method validates the provided URL string and then generates a `Cobweb.HTTP.Request` object configured with the PUT method, returning an instance initialized with this request.
    ///
    /// - Parameter urlString: The string representation of the URL for the PUT request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the PUT method and the specified URL.
    /// - Throws: `Cobweb.HTTP.RequestError.invalidURLString` if the PUT string is not valid.
    static func put(_ urlString: String) throws -> Self {
        try Self.put(validateURLString(urlString))
    }
    
    /// Creates a `Cobweb.HTTP.Request` configured with a PUT request for the specified URL.
    ///
    /// This method generates a `Cobweb.HTTP.Request` object configured with the PUT method and the provided URL, returning an instance initialized with this request.
    ///
    /// - Parameter url: The URL for the GET request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the PUT method and the specified URL.
    static func put(_ url: URL) -> Self {
        Self.method(.put, url)
    }
    
    /// Creates a `Cobweb.HTTP.Request` instance configured with a DELETE request for the specified URL string.
    ///
    /// This method validates the provided URL string and then generates a `Cobweb.HTTP.Request` object configured with the DELETE method, returning an instance initialized with this request.
    ///
    /// - Parameter urlString: The string representation of the URL for the DELETE request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the DELETE method and the specified URL.
    /// - Throws: `Cobweb.HTTP.RequestError.invalidURLString` if the URL string is not valid.
    static func delete(_ urlString: String) throws -> Self {
        try Self.delete(validateURLString(urlString))
    }
    
    /// Creates a `Cobweb.HTTP.Request` configured with a DELETE request for the specified URL.
    ///
    /// This method generates a `Cobweb.HTTP.Request` object configured with the DELETE method and the provided URL, returning an instance initialized with this request.
    ///
    /// - Parameter url: The URL for the GET request.
    /// - Returns: An instance initialized with a `Cobweb.HTTP.Request` configured with the DELETE method and the specified URL.
    static func delete(_ url: URL) -> Self {
        Self.method(.delete, url)
    }
}

// MARK: - Header Functions
public extension Cobweb.HTTP.Request {
    
    /// Sets multiple HTTP headers for the request.
    ///
    /// This method sets the values of the specified HTTP header fields for the request and returns the modified request instance. The headers are provided as a variadic parameter.
    ///
    /// - Parameter headers: A comma-separated list of HTTP headers to set for the request.
    /// - Returns: The modified request instance with the specified HTTP headers set.
    func withHeaders(_ headers: Cobweb.HTTP.Header...) -> Self {
        withHeaders(headers)
    }
    
    /// Sets multiple HTTP headers for the request.
    ///
    /// This method sets the values of the specified HTTP header fields for the request and returns the modified request instance. The headers are provided as an array.
    ///
    /// - Parameter headers: An array of HTTP headers to set for the request.
    /// - Returns: The modified request instance with the specified HTTP headers set.
    func withHeaders(_ headers: [Cobweb.HTTP.Header]) -> Self {
        for header in headers {
            self.request.setValue(header.value, forHTTPHeaderField: header.field)
        }
        return self
    }
}

// MARK: - Body Functions
public extension Cobweb.HTTP.Request {
    
    /// Sets the HTTP body of the request with an encodable object as JSON.
    ///
    /// This method encodes the provided encodable object into JSON data using the specified JSON encoder and sets it as the HTTP body of the request. It returns the modified request instance.
    ///
    /// - Parameters:
    ///   - jsonEncodable: The encodable object to set as the HTTP body of the request.
    ///   - encoder: The JSON encoder to use for encoding the object. Defaults to `JSONEncoder()`.
    /// - Returns: The modified request instance with the specified HTTP body set.
    /// - Throws: An error if the object cannot be encoded as JSON.
    func withBody<Body: Encodable>(_ jsonEncodable: Body, encoder: JSONEncoder = JSONEncoder()) throws -> Self {
        let data = try encoder.encode(jsonEncodable)
        return withBody(data)
    }
    
    /// Sets the HTTP body of the request with a string.
    ///
    /// This method converts the provided string into UTF-8 encoded data and sets it as the HTTP body of the request. It returns the modified request instance.
    ///
    /// - Parameter str: The string to set as the HTTP body of the request.
    /// - Returns: The modified request instance with the specified HTTP body set.
    /// - Throws: An error if the string cannot be converted to data.
    func withBody(_ str: String) throws -> Self {
        return withBody(Data(str.utf8))
    }
    
    /// Sets the HTTP body of the request with raw data.
    ///
    /// This method sets the provided data as the HTTP body of the request and returns the modified request instance.
    ///
    /// - Parameter data: The data to set as the HTTP body of the request.
    /// - Returns: The modified request instance with the specified HTTP body set.
    func withBody(_ data: Data) -> Self {
        self.request.httpBody = data
        return self
    }
}

// MARK: - Response Functions
public extension Cobweb.HTTP.Request {
    /// Sends the request and returns a response.
    ///
    /// This method sends the configured request using the session and returns a `Network.Response` object containing the response data and URL response.
    ///
    /// - Returns: A `Network.Response` object containing the response data and URL response.
    /// - Throws: An error if the request fails.
    @discardableResult
    func response() async throws -> Cobweb.HTTP.Response {
        let (data, urlResponse) = try await self.session.data(for: self.request)
        return Cobweb.HTTP.Response(data: data, response: urlResponse)
    }
    
    /// Sends the request and returns a byte stream response.
    ///
    /// This method sends the configured request using the session and returns a `Network.ByteStream` object containing the response byte stream and URL response.
    ///
    /// - Returns: A `Network.ByteStream` object containing the response byte stream and URL response.
    /// - Throws: An error if the request fails.
    /// - Availability: This method is available on iOS 15.0 and macOS 12.0 or newer.
    @available(iOS 15.0, macOS 12.0, *)
    func responseStream() async throws -> Cobweb.HTTP.ByteStream {
        let (bytes, urlResponse) = try await self.session.bytes(for: self.request)
        return Cobweb.HTTP.ByteStream(bytes: bytes, response: Cobweb.HTTP.Response(data: nil, response: urlResponse))
    }
    
    /// Sends the request and returns the response body data.
    ///
    /// This method sends the configured request using the session and returns the raw data from the response body.
    ///
    /// - Returns: The raw data from the response body.
    /// - Throws: An error if the request fails or the response data cannot be retrieved.
    func responseBodyData() async throws -> Data {
        return try await self.response().bodyData()
    }
    
    /// Sends the request and returns the decoded response body.
    ///
    /// This method sends the configured request using the session and decodes the response body into the specified type using the provided JSON decoder.
    ///
    /// - Parameter decoder: The JSON decoder to use for decoding the response body. Defaults to `JSONDecoder()`.
    /// - Returns: The decoded response body of the specified type.
    /// - Throws: An error if the request fails or the response body cannot be decoded.
    func responseBody<Body: Decodable>(using decoder: JSONDecoder = JSONDecoder()) async throws -> Body {
        return try await self.response().body(decoder)
    }
    
    /// Sends the request and returns the decoded response body for the specified type.
    ///
    /// This method sends the configured request using the session and decodes the response body into the specified type using the provided JSON decoder.
    ///
    /// - Parameters:
    ///   - type: The type to decode the response body into.
    ///   - decoder: The JSON decoder to use for decoding the response body. Defaults to `JSONDecoder()`.
    /// - Returns: The decoded response body of the specified type.
    /// - Throws: An error if the request fails or the response body cannot be decoded.
    func responseBody<Body: Decodable>(as type: Body.Type, using decoder: JSONDecoder = JSONDecoder()) async throws -> Body {
        return try await self.response().body(decoder)
    }
}
