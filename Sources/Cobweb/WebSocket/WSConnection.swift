//
//  WSConnection.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

import Foundation

public extension Cobweb.WebSocket {
    
    /// `Connection` represents a WebSocket network connection.
    final class Connection: Sendable {
        
        /// The internal task that drives the WebSocket connection.
        private let task: URLSessionWebSocketTask
        
        /// Creates and starts the `Cobweb.WebSocket.Connection`.
        internal init(request: Cobweb.WebSocket.Request) {
            self.task = request.session.webSocketTask(with: request.request)
            self.task.resume()
        }
    }
    
    /// `Message` represents a value that is sent or received over the WebSocket connection.
    struct Message {
        
        /// The message that is sent / received over the connection.
        public let message: URLSessionWebSocketTask.Message
        
        /// The `Data` included in the message. Is nil if the message is not the `.data` type.
        public var data: Data? { if case .data(let data) = message { return data } else { return nil } }
        
        /// The `String` included in the message. Is nil if the message is not the `.string` type.
        public var string: String? { if case .string(let string) = message { return string } else { return nil } }
        
        /// Decodes the message to the desired type.
        ///
        /// This method will attempt to decode the given type from the `Message`.
        ///
        /// - Parameters:
        ///   - type: The `Decodable` type to decode from the message.
        ///   - decoder: The `JSONDecoder` to use to decode the message. Defaults to `JSONDecoder()`.
        /// - Returns: The decoded value from the message.
        /// - Throws: `MessageError.expectedDataButReceivedStringResponse` if the message is not the `.data` type, or an error if the data cannot be decoded into the specified type.
        public func decoded<D: Decodable>(as type: D.Type = D.self, using decoder: JSONDecoder = JSONDecoder()) throws -> D {
            guard case .data(let data) = message
            else { throw MessageError.expectedDataButReceivedStringResponse }
            
            return try JSONDecoder().decode(D.self, from: data)
        }
        
        enum MessageError: Error {
            case expectedDataButReceivedStringResponse
        }
    }
}

// MARK: - Sending Values
public extension Cobweb.WebSocket.Connection {
    
    /// Sends a `String` message through this `Connection`.
    ///
    /// - Parameter message: The `String` message to send over the WebSocket connection.
    func send(_ message: String) async throws {
        try await self.task.send(.string(message))
    }
    
    /// Sends a `Data` message through this `Connection`.
    ///
    /// - Parameter data: The `Data` message to send over the WebSocket connection.
    func send(_ data: Data) async throws {
        try await self.task.send(.data(data))
    }
    
    /// Sends a `Data` message by encoding the provided value through this `Connection`.
    ///
    /// - Parameters:
    ///   - value: The encodable value to send over the WebSocket connection.
    ///   - encoder: The JSON encoder to use for encoding the object. Defaults to `JSONEncoder()`
    /// - Throws: An error if the object cannot be encoded as JSON or sent over the WebSocket connection.
    func send<E: Encodable>(_ value: E, with encoder: JSONEncoder = JSONEncoder()) async throws {
        try await self.task.send(.data(JSONEncoder().encode(value)))
    }
    
    /// Cancels the current WebSocket connection, providing no code or reason.
    func cancel() {
        self.task.cancel()
    }
    
    /// Cancels the current WebSocket connection, providing a close code and a data object for the reason.
    ///
    /// - Parameters:
    ///   - code: A code used to represent the type of cancelation with the connection.
    ///   - reason: A `Data` representing the reason for the closure. Defaults to `nil`.
    func cancel(with code: URLSessionWebSocketTask.CloseCode, reason: Data? = nil) {
        self.task.cancel(with: code, reason: reason)
    }
    
    /// Cancels the current WebSocket connection, providing a close code and a String for the reason.
    ///
    /// - Parameters:
    ///   - code: A code used to represent the type of cancelation with the connection.
    ///   - reason: A `String` representing the reason for the closure.
    func cancel(with code: URLSessionWebSocketTask.CloseCode, reason: String) {
        self.task.cancel(with: code, reason: reason.data(using: .utf8))
    }
    
    /// Cancels the current WebSocket connection, providing a close code and an encoded object for the reason.
    ///
    /// - Parameters:
    ///   - code: A code used to represent the type of cancelation with the connection.
    ///   - reason: An encodable value representing the reason for the closure.
    func cancel<E: Encodable>(with code: URLSessionWebSocketTask.CloseCode, reason: E, encoder: JSONEncoder = JSONEncoder()) throws {
        try self.task.cancel(with: code, reason: encoder.encode(reason))
    }

    /// Sends a ping to the other side of the WebSocket connection, awaiting a pong response.
    ///
    /// - Throws: An error if an `NSError` that indicates a lost connection or other problem is found.
    func ping() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            self.task.sendPing { error in
                if let error { continuation.resume(throwing: error) }
                else { continuation.resume() }
            }
        }
    }
}

// MARK: - Receiving Values
extension Cobweb.WebSocket.Connection: AsyncSequence {
    public typealias Element = Cobweb.WebSocket.Message
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(task: self.task)
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        let task: URLSessionWebSocketTask
        
        public func next() async throws -> Element? {
            do {
                return try await Cobweb.WebSocket.Message(message: task.receive())
            } catch let error as NSError {
                // User initiated connection cancel.
                if error.code == 57 && task.state == .canceling { return nil }
                throw error
            }
        }
    }
}
