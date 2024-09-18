//
//  HTTPHeader.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

public extension Cobweb.HTTP {
    
    /// A header in an HTTP request or response.
    struct Header {
        /// The field of the header.
        public let field: String
        
        /// The value of the header.
        public let value: String?
        
        internal init(field: String, value: String?) {
            self.field = field
            self.value = value
        }
    }
}

/// A collection of predefined HTTP headers.
public extension Cobweb.HTTP.Header {
    
    /// A custom HTTP header.
    static func custom(_ field: String, value: CustomStringConvertible?) -> Self {
        return self.init(field: field, value: value?.description)
    }
    
    /// The `Accept` header.
    static func accept<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Accept", value: value.description)
    }
    
    /// The `Accept-Charset` header.
    static func acceptCharset<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Accept-Charset", value: value.description)
    }
    
    /// The `Accept-Encoding` header.
    static func acceptEncoding<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Accept-Encoding", value: value.description)
    }
    
    /// The `Accept-Language` header.
    static func acceptLanguage<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Accept-Language", value: value.description)
    }
    
    /// The `Accept-Datetime` header.
    static func acceptDatetime<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Accept-Datetime", value: value.description)
    }
    
    /// The `Access-Control-Request-Method` header.
    static func accessControlRequestMethod<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Access-Control-Request-Method", value: value.description)
    }
    
    /// The `Access-Control-Request-Headers` header.
    static func accessControlRequestHeaders<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Access-Control-Request-Headers", value: value.description)
    }
    
    /// The `Authorization` header.
    static func authorization<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Authorization", value: value.description)
    }
    
    /// The `Cache-Control` header.
    static func cacheControl<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Cache-Control", value: value.description)
    }
    
    /// The `Connection` header.
    static func connection<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Connection", value: value.description)
    }
    
    /// The `Content-Length` header.
    static func contentLength<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Content-Length", value: value.description)
    }
    
    /// The `Content-Type` header.
    static func contentType<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Content-Type", value: value.description)
    }
    
    /// The `Cookie` header.
    static func cookie<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Cookie", value: value.description)
    }
    
    /// The `Date` header.
    static func date<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Date", value: value.description)
    }
    
    /// The `Expect` header.
    static func expect<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Expect", value: value.description)
    }
    
    /// The `Forwarded` header.
    static func forwarded<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Forwarded", value: value.description)
    }
    
    /// The `From` header.
    static func from<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "From", value: value.description)
    }
    
    /// The `Host` header.
    static func host<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Host", value: value.description)
    }
    
    /// The `If-Match` header.
    static func ifMatch<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "If-Match", value: value.description)
    }
    
    /// The `If-Modified-Since` header.
    static func ifModifiedSince<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "If-Modified-Since", value: value.description)
    }
    
    /// The `If-None-Match` header.
    static func ifNoneMatch<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "If-None-Match", value: value.description)
    }
    
    /// The `If-Range` header.
    static func ifRange<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "If-Range", value: value.description)
    }
    
    /// The `If-Unmodified-Since` header.
    static func ifUnmodifiedSince<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "If-Unmodified-Since", value: value.description)
    }
    
    /// The `Max-Forwards` header.
    static func maxForwards<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Max-Forwards", value: value.description)
    }
    
    /// The `Origin` header.
    static func origin<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Origin", value: value.description)
    }
    
    /// The `Pragma` header.
    static func pragma<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Pragma", value: value.description)
    }
    
    /// The `Proxy-Authorization` header.
    static func proxyAuthorization<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Proxy-Authorization", value: value.description)
    }
    
    /// The `Range` header.
    static func range<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Range", value: value.description)
    }
    
    /// The `Referer` header.
    static func referer<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Referer", value: value.description)
    }
    
    /// The `TE` header.
    static func te<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "TE", value: value.description)
    }
    
    /// The `User-Agent` header.
    static func userAgent<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "User-Agent", value: value.description)
    }
    
    /// The `Upgrade` header.
    static func upgrade<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Upgrade", value: value.description)
    }
    
    /// The `Via` header.
    static func via<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Via", value: value.description)
    }
    
    /// The `Warning` header.
    static func warning<V: CustomStringConvertible>(value: V) -> Self {
        return self.init(field: "Warning", value: value.description)
    }
}
