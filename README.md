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
us to override behaviour that's limited. Looks like [Alamofire](https://github.com/Alamofire/Alamofire)
is the most popular iOS networking library and all of the mentioned limitations can be solved 
with it. You also probably use Alamofire anyway to acquire authentication tokens for your 
GraphQL API, so it makes sense to integrate both Alamofire and Apollo iOS.

This package bundles a `NetworkTransport` implementation that wraps Alamofire
and solves these limitations.

## Example

When initialising a new `ApolloClient` instance instead of
```swift
let u = URL(string: "http://localhost:8080/graphql")!
let client = ApolloClient(url: u)
```
or instead of
```swift
let u = URL(string: "http://localhost:8080/graphql")!
let client = ApolloClient(networkTransport: HTTPNetworkTransport(url: u))
```

use

```swift
import ApolloAlamofire

//...
let u = URL(string: "http://localhost:8080/graphql")!
let client = ApolloClient(networkTransport: AlamofireTransport(url: u))
```

There are additional parameters available for `AlamofireTransport` initialiser, e.g. for 
a background session you can use it like this:

```swift
let c = URLSessionConfiguration.background(withIdentifier: "your-id")
let u = URL(string: "http://localhost:8080/graphql")!
let s = SessionManager(configuration: c)
let t = AlamofireTransport(url: u, sessionManager: s)
let client = ApolloClient(networkTransport: t)
```

like this for auth headers:


```swift
let token = "blah"
let u = URL(string: "http://localhost:8080/graphql")!
let h = ["Authorization": "Bearer \(token)"]
let t = AlamofireTransport(url: u, headers: h)
let client = ApolloClient(networkTransport: t)
```

or like this for request and response logging:

```swift
let u = URL(string: "http://localhost:8080/graphql")!
let t = AlamofireTransport(url: u, loggingEnabled: true)
let client = ApolloClient(networkTransport: t)
```

Both `headers` and `loggingEnabled` are also variable properties of `AlamofireTransport`.
This allows you to change headers without instantiating a new transport, e.g. when a user
logs out and a different user logs in you can swap authentication headers. If you switch 
logging dynamically, `loggingEnabled` property can be controlled in the same way 
without creating a new `AlamofireTransport` instance.

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
it, simply add the following line to your target configuration in your Podfile:

```ruby
pod 'ApolloAlamofire'
```

## Author

Max Desiatov

## License

ApolloAlamofire is available under the MIT license. See the [LICENSE](https://github.com/Alamofire/Alamofire/blob/master/LICENSE) file for more info.
