//
//  HTTPByteStream.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

import Foundation

public extension Cobweb.HTTP {
    /// Represents a stream of bytes from a network response.
    ///
    /// This class encapsulates an asynchronous sequence of bytes and the associated network response.
    @available(iOS 15.0, macOS 12.0, *)
    class ByteStream: AsyncSequence {
        public typealias AsyncIterator = URLSession.AsyncBytes.AsyncIterator
        public typealias Element = UInt8
        
        /// The asynchronous byte stream returned by the network request.
        private var bytes: URLSession.AsyncBytes
        
        /// The network response associated with the byte stream.
        private var response: Cobweb.HTTP.Response
        
        /// Initializes a new `ByteStream` instance with the specified byte stream and network response.
        ///
        /// - Parameters:
        ///   - bytes: The asynchronous byte stream returned by the network request.
        ///   - response: The network response associated with the byte stream.
        internal init(bytes: URLSession.AsyncBytes, response: Cobweb.HTTP.Response) {
            self.bytes = bytes
            self.response = response
        }
        
        /// Creates an asynchronous iterator over the byte stream.
        ///
        /// - Returns: An asynchronous iterator over the byte stream.
        public func makeAsyncIterator() -> URLSession.AsyncBytes.AsyncIterator {
            bytes.makeAsyncIterator()
        }
    }
}
