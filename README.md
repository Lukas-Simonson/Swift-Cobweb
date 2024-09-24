<h1 align="center">🕸️ Cobweb</h1>

<p align="center">
    <strong>Swift Networking Made Better</strong><br>
</p>

<p align="center">
    <a href="https://developer.apple.com/swift/"><img alt="Swift 6.0" src="https://img.shields.io/badge/swift-6.0-orange.svg?style=flat"></a>
    <a href="LICENSE"><img alt="license" src="https://img.shields.io/badge/license-MIT-black.svg"></a>
</p>

## Overview
Cobweb is a thin and light wrapper around Foundation.URLSession and its functionality. Cobweb is meant to provide a cleaner way to make URLRequests and work with the information received back from them.

## Quickstart Guide

### Making URLs

Cobweb is meant to make the entire process of making network requests easy and fun! This includes the process of creating URLs. By leveraging a builder pattern, Cobweb allows you to create URLs in a declarative manner.

Here is an example of how you can create a URL for `https://www.google.com/`

```swift
Cobweb.URL.host("google.com")
```
Cobweb uses https as its default schema, but you can also choose to set your schema by chaining another function, or even starting with that function.

For example if you wanted to go to `http://www.google.com`.

```swift
Cobweb.URL.scheme(.http).host("google.com")
```
You can continue to modify the URL by chaining more functions. For example, if we want to change what path we are going to, we can chain the `.path` function.

```swift
Cobweb.URL.host("example.com")
    .path("/sub/page")
```
I could then set the query of my URL by chaining the `.query` function.

```swift
Cobweb.URL.host("example.com")
    .path("/sub/page")
    .query("param1=400,param2=hello")
```
#### Creating a `Cobweb.HTTP.Request` from a `Cobweb.URL`

Once you have created your `Cobweb.URL` you can easily convert it into a `Cobweb.HTTP.Request` by using the `.request` function. This function takes a parameter for what HTTP Method you want to use for your request. There are also some short hand functions such as `.get` that create the request for the most common HTTP Methods.

This function can throw if you haven't provided enough information to create a URL from.

```swift
try Cobweb.URL.host("example.com")
    .path("/sub/page")
    .query("param1=400,param2=hello")
    .request(method: .get)

// OR

try Cobweb.URL.host("example.com")
    .path("/sub/page")
    .query("param1=400,param2=hello")
    .get()
```

### Working With `Cobweb.HTTP.Request`

#### Creating a `Cobweb.HTTP.Request`
If you don't want / need to work with `Cobweb.URL` you can still create a `Cobweb.HTTP.Request` using either a Foundation `URL` or just a `String`. There are several static functions built in to help you create requests.

Similar to how there is a `.request` function for `Cobweb.URL` there is also a static version for `Cobweb.HTTP.Request` that lets you specify a HTTP Method and a URL to use for the request. There are also the same convenience functions for the most common HTTP methods such as `.get`.

Here is how you could create the same request we made in the last `Cobweb.URL` example just using a `String`.

```swift
try Cobweb.HTTP.Request
    .get("https://www.example.com/sub/page?param1=400,param2=hello")
```

#### Setting Request Headers
In order to set the request headers of a `Cobweb.HTTP.Request` there are a couple of different functions you can use. Each of these different functions rely on being passed a `Cobweb.HTTP.Header` value.

`Cobweb.HTTP.Header` is a type used to represent an individual header in a `Cobweb.HTTP.Request`. You can create one of these headers using the `.custom` static function, or by using one of the many provided static functions for commonly used headers, such as `.authorization`.

For this example, lets set a few different headers onto the request we made in the Creating a `Cobweb.HTTP.Request` section.

```swift
try Cobweb.HTTP.Request
    .get("https://www.example.com/sub/page?param1=400,param2=hello")
    .withHeaders(.contentType(value: "application/json"), .custom("X-API-KEY", value: "myapikeyhere"))
```
#### Setting The Request Body
Setting the body of a request is as easy as all of the other things. You use the `.withBody` function of the `Cobweb.Request`. There are 3 different versions of this function.

1. `withBody(_ jsonEncodable: Encodable, encoder: JSONEncoder = JSONEncoder())`
2. `withBody(_ str: String)`
3. `withBody(_ data: Data)`

Each of these options does the same thing, just using a different type of data.

As an example, here is a continuation of the last example, while adding a String as the body of the request.

```swift
try Cobweb.HTTP.Request
    // Changed to post as you cannot have a body on a get request.
    .post("https://www.example.com/sub/page?param1=400,param2=hello")
    .withHeaders(.contentType(value: "application/json"), .custom("X-API-KEY", value: "myapikeyhere"))
    .withBody("This is my Response Body")
```
#### Getting Data From The Request

To make send a `Cobweb.HTTP.Request` you use the `async` `.response` function. This will cause the set `URLSession` to make the actual request and it will return the information you get back in the form of a `Cobweb.HTTP.Response`

Here is how you could get the data back from the previous example.

```swift
// Added await as the call to `.response` is async
try await Cobweb.HTTP.Request
    .post("https://www.example.com/sub/page?param1=400,param2=hello")
    .withHeaders(.contentType(value: "application/json"), .custom("X-API-KEY", value: "myapikeyhere"))
    .withBody("This is my Response Body")
    .response()
```
If you only care about the body of your request, you can choose to skip the response in favor of just getting the body data back. You can do this by using one of the various `.responseBody` functions.

```swift
// Added await as the call to `.response` is async
try await Cobweb.HTTP.Request
    .post("https://www.example.com/sub/page?param1=400,param2=hello")
    .withHeaders(.contentType(value: "application/json"), .custom("X-API-KEY", value: "myapikeyhere"))
    .withBody("This is my Response Body")
    .responseBody(as: ExampleDecodable.self)
```
### Working With `Cobweb.HTTP.Response`
The only way to get an instance of a `Cobweb.HTTP.Response` is by using the `.response` function from a `Cobweb.HTTP.Request`. After this is done, there are several functions that help you handle the response you receive.

#### Reading the Response Body
You can get the data from the responses body via the `.body` and `.bodyData` functions. These functions either convert `Decodable` types using a `JSONDecoder` or give back the `Data` object respectively.

```swift
try await Cobweb.HTTP.Request
    .post("https://www.example.com/sub/page?param1=400,param2=hello")
    .withHeaders(.contentType(value: "application/json"), .custom("X-API-KEY", value: "myapikeyhere"))
    .withBody("This is my Response Body")
    .response()
    .bodyData() // Get the Data object from the `Cobweb.HTTP.Response`
```

#### Responding to Response Status Codes
Often you need to verify the status codes of the response you get back from the network request. You can use the `.verifyStatusCode` function to throw errors based on the status code.

```swift
try await Cobweb.HTTP.Request
    .post("https://www.example.com/sub/page?param1=400,param2=hello")
    .withHeaders(.contentType(value: "application/json"), .custom("X-API-KEY", value: "myapikeyhere"))
    .withBody("This is my Response Body")
    .response()
    .verifyStatusCode(is: 200, orThrow: NetworkError.invalidResponse)
    .bodyData() // Get the Data object from the `Cobweb.HTTP.Response`
```
## See The Difference

### With Normal URLSession
```swift
func postUser(user: User, bearerToken token: String) async throws -> User {
    guard let url = URL(string: "https://example.com/user")
    else { throw ServiceError.invalidURL }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.httpBody = try JSONEncoder().encode(user)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    switch (response as? HTTPURLResponse)?.statusCode {
        case 200: break
        case 400: throw ServiceError.badRequest
        case 500: throw ServiceError.serverError
        default: throw ServiceError.unknownError
    }
    
    return try JSONDecoder().decode(User.self, from: data)
}
```
### With ComposeHTTP
```swift
func postUser(user: User, bearerToken token: String) async throws -> User {
    try await Cobweb.HTTP.Request
        .post("https://example.com/user")
        .withHeaders(.contentType(value: "application/json"), .authorization(value: "Bearer \(token)"))
        .withBody(user)
        .response()
        .verifyStatusCode(isNot: 400, orThrow: ServiceError.badRequest)
        .verifyStatusCode(isNot: 500, orThrow: ServiceError.serverError)
        .verifyStatusCode(is: 200, orThrow: ServiceError.unknownError)
        .body()
}
```

## Installation

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

To add [ComposeHTTP](https://github.com/Lukas-Simonson/swift-composehttp) to your project do the following.
- Open Xcode
- Click on `File -> Add Packages`
- Use this repositories URL (https://github.com/Lukas-Simonson/Swift-ComposeHTTP.git) in the top right of the window to download the package.
- When prompted for a Version or a Branch, we suggest you use the branch: main


