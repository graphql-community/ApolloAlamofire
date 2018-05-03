# ApolloAlamofire

[![CI Status](https://img.shields.io/travis/maxdesiatov/ApolloAlamofire.svg?style=flat)](https://travis-ci.org/maxdesiatov/ApolloAlamofire)
[![Version](https://img.shields.io/cocoapods/v/ApolloAlamofire.svg?style=flat)](https://cocoapods.org/pods/ApolloAlamofire)
[![License](https://img.shields.io/cocoapods/l/ApolloAlamofire.svg?style=flat)](https://cocoapods.org/pods/ApolloAlamofire)
[![Platform](https://img.shields.io/cocoapods/p/ApolloAlamofire.svg?style=flat)](https://cocoapods.org/pods/ApolloAlamofire)

## What's This For?

If you've used [Apollo iOS](https://github.com/apollographql/apollo-ios) library,
you may have stumbled upon a few limitations of a standard `HTTPNetworkTransport`
provided with the library:

* [Can't swap request headers without creating a new `ApolloClient` instance](https://github.com/apollographql/apollo-ios/issues/37)
* [Can't send requests when the app is in background](https://stackoverflow.com/questions/50089546/how-to-correctly-use-apollo-graphql-on-ios-with-background-session-configuration)
* [Can't log request/response data](https://github.com/apollographql/apollo-ios/pull/257)

Fortunately, Apollo iOS provides a public `NetworkTransport` protocol that allows 
overcoming these limitations. Given that [Alamofire](https://github.com/Alamofire/Alamofire)
is the most popular iOS networking library , and you probably use it anyway to authenticate
with your GraphQL API, it makes sense to integrate both Alamofire and Apollo iOS.

All of the mentioned limitations can be solved with Alamofire and are bundled with this 
package.

## Example

When initialising a new `ApolloClient` instance instead of
```swift
let client = ApolloClient(url: URL(string: "http://localhost:8080/graphql")!)
```
or instead of
```swift
let client = ApolloClient(networkTransport: HTTPNetworkTransport(url: URL(string: "http://localhost:8080/graphql")!))
```

use

```swift
import ApolloAlamofire

//...

let client = ApolloClient(networkTransport: AlamofireTransport(url: URL(string: "http://localhost:8080/graphql")!))
```

There are additional parameters available for `AlamofireTransport` initialiser, e.g. for 
a background session you can use it like this:

```swift
let configuration = URLSessionConfiguration.background(withIdentifier: "your-id")

let client = ApolloClient(networkTransport: AlamofireTransport(url: URL(string: "http://localhost:8080/graphql")!, sessionManager: SessionManager(configuration: configuration)))
```

like this for auth headers:


```swift
let token = "blah"

let client = ApolloClient(networkTransport: AlamofireTransport(url: URL(string: "http://localhost:8080/graphql")!, headers: ["Authorization": "Bearer \(token)"]))
```

or like this for request and response logging:

```swift
let client = ApolloClient(networkTransport: AlamofireTransport(url: URL(string: "http://localhost:8080/graphql")!, loggingEnabled: true))
```

Nice feature of Alamofire is that request logging prints a ready for use 
[curl command](https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#curl-command-output), which you can directly copy and paste in terminal to test a request.

All of the initialiser parameters except `url` have sensible default values and can be used
in a combination that works best for you.

To run the example project, clone the repo, and open `Example/ApolloAlamofire.xcworkspace` in Xcode.

## Requirements

The library is tested with Xcode 9.3 and Swift 4.1. It should compile in any other version of
Xcode 9 and should be compatible with Swift 4.0, but is not tested with those version. 
Feel free to submit a PR to enable a better [Travis CI testing matrix](https://github.com/maxdesiatov/ApolloAlamofire/blob/master/.travis.yml).

If you integrate the library with CocoaPods, Alamofire and Apollo iOS dependencies are 
pulled automatically. Currently tested versions that should be compatible are Alamofire 4.x
and Apollo iOS 0.8.x.

## Installation

ApolloAlamofire is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ApolloAlamofire'
```

## Author

Max Desiatov

## License

ApolloAlamofire is available under the MIT license. See the [LICENSE](https://github.com/Alamofire/Alamofire/blob/master/LICENSE) file for more info.
