//
//  AlamofireTransport.swift
//
//  Created by Max Desiatov on 1/05/2018.
//  Copyright © 2018 Max Desiatov
//

import Alamofire
import Apollo
import Foundation

/// A network transport that uses HTTP POST requests to send GraphQL operations
/// to a server, and that uses `Alamofire.SessionManager` as the networking
/// implementation.
public class AlamofireTransport: NetworkTransport {
  let sessionManager: SessionManager
  let url: URL
  public var headers: HTTPHeaders?
  public var loggingEnabled: Bool
  public var clientName: String
  public var clientVersion: String

  public init(
    url: URL,
    sessionManager: SessionManager = SessionManager.default,
    headers: HTTPHeaders? = nil,
    loggingEnabled: Bool = false,
    clientName: String = "ApolloAlamofire",
    clientVersion: String = "0.6.0"
  ) {
    self.sessionManager = sessionManager
    self.url = url
    self.headers = headers
    self.loggingEnabled = loggingEnabled
    self.clientName = clientName
    self.clientVersion = clientVersion
  }

  public func send<Operation>(
    operation: Operation,
    completionHandler: @escaping (Swift.Result<GraphQLResponse<Operation>, Error>) -> ()
  )
    -> Cancellable where Operation: GraphQLOperation {
    let vars: JSONEncodable = operation.variables?.mapValues { $0?.jsonValue }
    let body: Parameters = [
      "query": operation.queryDocument,
      "variables": vars,
    ]
    let request = sessionManager
      .request(url, method: .post, parameters: body,
               encoding: JSONEncoding.default, headers: headers)
      .validate(statusCode: [200])
    if loggingEnabled {
      debugPrint(request)
    }
    return request.responseJSON { response in
      let result = response.result
        .flatMap { value -> GraphQLResponse<Operation> in
          guard let value = value as? JSONObject else {
            throw response.error!
          }
          if self.loggingEnabled, let data = response.data,
            let str = String(data: data, encoding: .utf8) {
            print(str)
          }
          return GraphQLResponse(operation: operation, body: value)
        }

      switch result {
      case let .failure(error):
        completionHandler(.failure(error))
      case let .success(value):
        completionHandler(.success(value))
      }
    }.task!
  }
}
