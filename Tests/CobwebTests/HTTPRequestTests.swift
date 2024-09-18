//
//  HTTPRequestTests.swift
//  Cobweb
//
//  Created by Lukas Simonson on 9/18/24.
//

import Testing
import Foundation
@testable import Cobweb

@Suite
struct HTTPRequestTests { }

// MARK: - Builder Method Tests
extension HTTPRequestTests {
    
    @Test(arguments: Cobweb.HTTP.Method.allCases)
    func methodBuilder(_ method: Cobweb.HTTP.Method) throws {
        let stringRequest = try Cobweb.HTTP.Request.method(method, "https://example.com")
        #expect(stringRequest.request.httpMethod == method.name)
        
        let urlRequest = Cobweb.HTTP.Request.method(method, URL(string: "https://example.com")!)
        #expect(urlRequest.request.httpMethod == method.name)
    }
    
    @Test
    func getBuilder() throws {
        let stringRequest = try Cobweb.HTTP.Request.get("https://example.com")
        #expect(stringRequest.request.httpMethod == "GET")
        
        let urlRequest = Cobweb.HTTP.Request.get(URL(string: "https://example.com")!)
        #expect(urlRequest.request.httpMethod == "GET")
    }

    @Test
    func postBuilder() throws {
        let stringRequest = try Cobweb.HTTP.Request.post("https://example.com")
        #expect(stringRequest.request.httpMethod == "POST")
        
        let urlRequest = Cobweb.HTTP.Request.post(URL(string: "https://example.com")!)
        #expect(urlRequest.request.httpMethod == "POST")
    }
    
    @Test
    func putBuilder() throws {
        let stringRequest = try Cobweb.HTTP.Request.put("https://example.com")
        #expect(stringRequest.request.httpMethod == "PUT")
        
        let urlRequest = Cobweb.HTTP.Request.put(URL(string: "https://example.com")!)
        #expect(urlRequest.request.httpMethod == "PUT")
    }
    
    @Test
    func deleteBuilder() throws {
        let stringRequest = try Cobweb.HTTP.Request.delete("https://example.com")
        #expect(stringRequest.request.httpMethod == "DELETE")
        
        let urlRequest = Cobweb.HTTP.Request.delete(URL(string: "https://example.com")!)
        #expect(urlRequest.request.httpMethod == "DELETE")
    }
}

// MARK: - Builder Header Tests
extension HTTPRequestTests {
    @Test
    func headerBuilder() throws {
        let request = try Cobweb.HTTP.Request.get("https://example.com")
            .setHeaders(.authorization(value: "Bearer someToken"), .custom("X-API-Key", value: "KeyValue"), .contentType(value: "application/json"))
        
        #expect(request.request.value(forHTTPHeaderField: "Authorization") == "Bearer someToken")
        #expect(request.request.value(forHTTPHeaderField: "X-API-Key") == "KeyValue")
        #expect(request.request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }
    
    @Test
    func headerArrayBuilder() throws {
        let request = try Cobweb.HTTP.Request.get("https://example.com")
            .setHeaders([.authorization(value: "Bearer someToken"), .custom("X-API-Key", value: "KeyValue"), .contentType(value: "application/json")])
        
        #expect(request.request.value(forHTTPHeaderField: "Authorization") == "Bearer someToken")
        #expect(request.request.value(forHTTPHeaderField: "X-API-Key") == "KeyValue")
        #expect(request.request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }
    
    @Test
    func headerBuilderOverwritesExisting() throws {
        let request = try Cobweb.HTTP.Request.get("https://example.com")
            .setHeaders(.authorization(value: "Bearer someToken"))
            .setHeaders(.authorization(value: "Bearer someOtherToken"))
        
        #expect(request.request.value(forHTTPHeaderField: "Authorization") == "Bearer someOtherToken")
    }
}

// MARK: - Builder Body Tests
extension HTTPRequestTests {
    
    @Test(arguments: [ExampleCodableValue(title: "Title One", description: "Description One"), ExampleCodableValue(title: "Title Two", description: "Description Two")])
    func builderBodyEncodable(_ value: ExampleCodableValue) throws {
        let request = try Cobweb.HTTP.Request.get("https://example.com")
            .setBody(value)
        
        let unwrapped = try #require(request.request.httpBody)
        #expect(try JSONDecoder().decode(ExampleCodableValue.self, from: unwrapped) == value)
    }
    
    @Test
    func builderBodyEncodableUsesCustomDecoder() throws {
        let valueToEncode = ExampleCodableValue(title: "Title One", description: "Description One")
        
        // Test Basic Encoder
        let basicEncoderRequest = try Cobweb.HTTP.Request.get("https://example.com")
            .setBody(valueToEncode, encoder: JSONEncoder())
        
        let unwrapped = try #require(basicEncoderRequest.request.httpBody)
        #expect(try JSONDecoder().decode(ExampleCodableValue.self, from: unwrapped) == valueToEncode)
        
        // Test Empty Encoder
        let emptyEncoderRequest = try Cobweb.HTTP.Request.get("https://example.com")
            .setBody(valueToEncode, encoder: EmptyEncoder())
        
        let unwrappedEmpty = try #require(emptyEncoderRequest.request.httpBody)
        #expect(unwrappedEmpty.isEmpty)
    }
    
    @Test(arguments: ["Hello, World", "Foo bar", "Some random string", ""])
    func builderBodyString(_ str: String) throws {
        let request = try Cobweb.HTTP.Request.get("https://example.com")
            .setBody(str)
        
        //request.request.httpBody
        let unwrapped = try #require(request.request.httpBody)
        #expect(String(data: unwrapped, encoding: .utf8) == str)
    }
    
    @Test(arguments: [Data(), "Example".data(using: .utf8)!])
    func builderBodyData(_ data: Data) throws {
        let request = try Cobweb.HTTP.Request.get("https://example.com")
            .setBody(data)
        
        let unwrapped = try #require(request.request.httpBody)
        #expect(unwrapped == data)
    }
}
