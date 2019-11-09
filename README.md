# ApolloAlamofire

### Alamofire transport implementation for Apollo GraphQL iOS library.

[![CI Status](https://img.shields.io/travis/graphql-community/ApolloAlamofire/master.svg?style=flat)](https://travis-ci.org/graphql-community/ApolloAlamofire/)
[![Version](https://img.shields.io/cocoapods/v/ApolloAlamofire.svg?style=flat)](https://cocoapods.org/pods/ApolloAlamofire)
[![License](https://img.shields.io/cocoapods/l/ApolloAlamofire.svg?style=flat)](https://cocoapods.org/pods/ApolloAlamofire)
[![Platform](https://img.shields.io/cocoapods/p/ApolloAlamofire.svg?style=flat)](https://cocoapods.org/pods/ApolloAlamofire)

## What's This For?

If you used [Apollo iOS](https://github.com/apollographql/apollo-ios) library,
you may have stumbled upon a few limitations of a standard `HTTPNetworkTransport`
provided with the library:

- [Can't swap request headers without creating a new `ApolloClient` instance](https://github.com/apollographql/apollo-ios/issues/37)
- [Can't send requests when the app is in background](https://stackoverflow.com/questions/50089546/how-to-correctly-use-apollo-graphql-on-ios-with-background-session-configuration)
- [Can't log request/response data](https://github.com/apollographql/apollo-ios/pull/257)

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

- Xcode 10.0 or later
- Swift 4.2 or later
- iOS 9.0 deployment target or later.

If you integrate the library with CocoaPods, Alamofire and Apollo iOS
dependencies are pulled automatically. Currently tested compatible versions are
Alamofire 4.x and Apollo iOS 0.10.x.

If you need Xcode 9 and Swift 4.0 support in your project you can use earlier
version of ApolloAlamofire: [0.3.0](https://github.com/graphql-community/ApolloAlamofire/tree/0.3.0).

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Swift and
Objective-C Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

Navigate to the project directory and create `Podfile` with the following
command:

```bash
$ pod install
```

Inside of your `Podfile`, specify the `ApolloAlamofire` pod:

```ruby
pod 'ApolloAlamofire', '~> 0.6.0'
```

Then, run the following command:

```bash
$ pod install
```

Open the the `YourApp.xcworkspace` file that was created. This should be the
file you use everyday to create your app, instead of the `YourApp.xcodeproj`
file.

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a dependency manager that
builds your dependencies and provides you with binary frameworks.

Carthage can be installed with [Homebrew](https://brew.sh/) using the following
command:

```bash
$ brew update
$ brew install carthage
```

Inside of your `Cartfile`, add GitHub path to `ApolloAlamofire`:

```ogdl
github "graphql-community/ApolloAlamofire" ~> 0.6.0
```

Then, run the following command to build the framework:

```bash
$ carthage update
```

Drag the built framework into your Xcode project.

## Maintainer

[Max Desiatov](https://desiatov.com)

## License

ApolloAlamofire is available under the MIT license. See the [LICENSE](https://github.com/Alamofire/Alamofire/blob/master/LICENSE) file for more info.
