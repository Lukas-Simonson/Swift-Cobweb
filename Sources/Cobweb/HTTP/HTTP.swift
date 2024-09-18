//
//  HTTP.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

public extension Cobweb {
    enum HTTP {
        
        /// Represents the scheme of an HTTP request.
        ///
        /// This enumeration defines the possible schemes for an HTTP request.
        public enum Scheme: String {
            
            /// The HTTP scheme.
            case http
            
            /// The HTTPS scheme.
            case https
        }
    }
}
