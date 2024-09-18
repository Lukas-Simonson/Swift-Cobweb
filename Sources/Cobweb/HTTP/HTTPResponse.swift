//
//  HTTPResponse.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

import Foundation

public extension Cobweb.HTTP {
    
    /// Represents a network response.
    ///
    /// This class encapsulates the response data and the URL response received from a network request.
    class Response {
        /// The data returned by the network request.
        private var data: Data?
        
        /// The URL response returned by the network request.
        private var response: URLResponse
        
        /// Cached response status code.
        private var _statusCode: Int? = nil
        
        /// The status code of this response.
        public var statusCode: Int {
            get throws {
                if let _statusCode { return _statusCode }
                else if let response = self.response as? HTTPURLResponse {
                    _statusCode = response.statusCode
                    return response.statusCode
                }
                else { throw ResponseError.invalidHTTPResponse }
            }
        }
        
        /// Initializes a new `Response` instance with the specified data and URL response.
        ///
        /// - Parameters:
        ///   - data: The data returned by the network request, if any.
        ///   - response: The URL response returned by the network request.
        internal init(data: Data?, response: URLResponse) {
            self.data = data
            self.response = response
        }
        
        enum ResponseError: Error {
            case invalidHTTPResponse
            case dataNotFound
            case couldntConvertData
        }
    }
}

public extension Cobweb.HTTP.Response {
    
    /// Retrieves the raw data from the response body.
    ///
    /// This method returns the raw data from the response body, if available.
    ///
    /// - Returns: The raw data from the response body.
    /// - Throws: `Network.ResponseError.dataNotFound` if the response body data is not available
    func bodyData() throws -> Data {
        guard let data else { throw ResponseError.dataNotFound }
        return data
    }
    
    /// Decodes the response body into a specified type.
    ///
    /// This method decodes the response body into the specified type using the provided JSON decoder.
    ///
    /// - Parameters:
    ///   - decoder: The JSON decoder to use for decoding the response body. Defaults to `JSONDecoder()`.
    /// - Returns: The decoded response body of the specified type.
    /// - Throws: `Network.ResponseError.dataNotFound` if the response body data is not available, or an error if the data cannot be decoded into the specified type.
    func body<Body: Decodable>(_ decoder: JSONDecoder = JSONDecoder()) throws -> Body {
        guard let data else { throw ResponseError.dataNotFound }
        return try decoder.decode(Body.self, from: data)
    }
    
    /// Decodes the response body into a specified type.
    ///
    /// This method decodes the response body into the specified type using the provided JSON decoder.
    ///
    /// - Parameters:
    ///   - type: The `Decodable` type to decode the response body as.
    ///   - decoder: The JSON decoder to use for decoding the response body. Defaults to `JSONDecoder()`.
    /// - Returns: The decoded response body of the specified type.
    /// - Throws: `Network.ResponseError.dataNotFound` if the response body data is not available, or an error if the data cannot be decoded into the specified type.
    func body<Body: Decodable>(as type: Body.Type, _ decoder: JSONDecoder = JSONDecoder()) throws -> Body {
        guard let data else { throw ResponseError.dataNotFound }
        return try decoder.decode(Body.self, from: data)
    }
    
    /// Converts the response body data into a string using the specified encoding.
    ///
    /// This method converts the response body data into a string using the specified encoding.
    ///
    /// - Parameters:
    ///   - encoding: The string encoding to use. Defaults to `.utf8`.
    /// - Returns: The response body data as a string.
    /// - Throws: `Network.ResponseError.dataNotFound` if the response body data is not available, or `Network.ResponseError.couldntConvertDataToString` if the data cannot be converted into a string using the specified encoding.
    func body(encoding: String.Encoding = .utf8) throws -> String {
        guard let data else { throw ResponseError.dataNotFound }
        guard let string = String(data: data, encoding: encoding)
        else { throw ResponseError.couldntConvertData }
        return string
    }
    
    /// Prints the JSON representation of the response body.
    ///
    /// This method prints the JSON representation of the response body, if available.
    ///
    /// - Parameter defaultString: The default string to print if the response body data is not available. Defaults to "Failed To Print JSON".
    /// - Returns: The current response instance.
    @discardableResult
    func printJSON(or defaultString: String = "Failed To Print JSON") -> Self {
        guard let data else { print(defaultString); return self }
        print(String(data: data, encoding: .utf8) ?? defaultString)
        return self
    }
}

// MARK: Response Validation
public extension Cobweb.HTTP.Response {
    
    /// Verifies that the HTTP status code is the specified value.
    ///
    /// This method checks if the HTTP status code is equal to the specified value. If not, it throws the specified error.
    ///
    /// - Parameters:
    ///   - code: The HTTP status code to verify against.
    ///   - error: The error to throw if the status code does not match.
    /// - Throws: The specified error if the status code does not match.
    @discardableResult
    func verifyStatusCode<E: Error>(is code: Int, orThrow error: E) throws -> Self {
        if try statusCode != code { throw error }
        return self
    }
    
    /// Verifies that the HTTP status code is the specified value.
    ///
    /// This method checks if the HTTP status code is equal to the specified value. If not, it decodes and throws the specified error type.
    ///
    /// - Parameters:
    ///   - code: The HTTP status code to verify against.
    ///   - type: The type of the error to throw if the status code does not match.
    /// - Throws: The specified error type if the status code does not match.
    @discardableResult
    func verifyStatusCode<E: Error & Decodable>(is code: Int, orDecodeAndThrow type: E.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        if try statusCode != code {
            throw try self.body(as: E.self, decoder)
        }
        return self
    }
    
    /// Verifies that the HTTP status code is in the specified range.
    ///
    /// This method checks if the HTTP status code is within the specified range. If not, it throws the specified error.
    ///
    /// - Parameters:
    ///   - range: The range of HTTP status codes to verify against.
    ///   - error: The error to throw if the status code does not match.
    /// - Throws: The specified error if the status code does not match.
    @discardableResult
    func verifyStatusCode<E: Error>(isIn range: ClosedRange<Int>, orThrow error: E) throws -> Self {
        let statusCode = try statusCode
        if range.lowerBound > statusCode || range.upperBound < statusCode { throw error }
        return self
    }
    
    /// Verifies that the HTTP status code is the specified value.
    ///
    /// This method checks if the HTTP status code is equal to the specified value. If not, it decodes and throws the specified error type.
    ///
    /// - Parameters:
    ///   - range: The range of HTTP status codes to verify against.
    ///   - type: The type of the error to throw if the status code does not match.
    /// - Throws: The specified error type if the status code does not match.
    @discardableResult
    func verifyStatusCode<E: Error & Decodable>(isIn range: ClosedRange<Int>, orDecodeAndThrow type: E.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        let statusCode = try statusCode
        if range.lowerBound > statusCode || range.upperBound < statusCode {
            throw try self.body(as: E.self, decoder)
        }
        return self
    }
    
    /// Verifies that the HTTP status code is not the specified value.
    ///
    /// This method checks if the HTTP status code is not equal to the specified value. If it is, it throws the specified error.
    ///
    /// - Parameters:
    ///   - code: The HTTP status code to verify against.
    ///   - error: The error to throw if the status code matches.
    /// - Throws: The specified error if the status code matches.
    @discardableResult
    func verifyStatusCode<E: Error>(isNot code: Int, orThrow error: E) throws -> Self {
        if try statusCode == code { throw error }
        return self
    }
    
    /// Verifies that the HTTP status code is not the specified value.
    ///
    /// This method checks if the HTTP status code is not equal to the specified value. If it is, it decodes and throws the specified error type.
    ///
    /// - Parameters:
    ///   - code: The HTTP status code to verify against.
    ///   - type: The type of the error to throw if the status code matches.
    /// - Throws: The specified error type if the status code matches.
    @discardableResult
    func verifyStatusCode<E: Error & Decodable>(isNot code: Int, orDecodeAndThrow type: E.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        if try statusCode == code {
            throw try self.body(as: E.self, decoder)
        }
        return self
    }
    
    
    /// Verifies that the HTTP status code is not in the specified range.
    ///
    /// This method checks if the HTTP status code is not within the specified range. If it is, it throws the specified error.
    ///
    /// - Parameters:
    ///   - range: The range of HTTP status codes to verify against.
    ///   - error: The error to throw if the status code does match.
    /// - Throws: The specified error if the status code does match.
    @discardableResult
    func verifyStatusCode<E: Error>(isNotIn range: ClosedRange<Int>, orThrow error: E) throws -> Self {
        let statusCode = try statusCode
        if range.lowerBound < statusCode && range.upperBound > statusCode { throw error }
        return self
    }
    
    /// Verifies that the HTTP status code is not in the specified value.
    ///
    /// This method checks if the HTTP status code is not in the specified range. If it is, it decodes and throws the specified error type.
    ///
    /// - Parameters:
    ///   - range: The range of HTTP status codes to verify against.
    ///   - type: The type of the error to throw if the status code does not match.
    /// - Throws: The specified error type if the status code does not match.
    @discardableResult
    func verifyStatusCode<E: Error & Decodable>(isNotIn range: ClosedRange<Int>, orDecodeAndThrow type: E.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        let statusCode = try statusCode
        if range.lowerBound < statusCode && range.upperBound > statusCode {
            throw try self.body(as: E.self, decoder)
        }
        return self
    }
}
