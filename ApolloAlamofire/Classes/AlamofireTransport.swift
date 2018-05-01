//
//  AlamofireTransport.swift
//
//  Created by Max Desiatov on 1/05/2018.
//  Copyright © 2018 Max Desiatov. All rights reserved.
//

import Foundation
import Apollo
import Alamofire

class AlamofireTransport: NetworkTransport {
  let sessionManager: SessionManager
  let url: URL
  let headers: HTTPHeaders?
  let loggingEnabled: Bool

  init(url: URL, sessionManager: SessionManager = SessionManager.default,
       headers: HTTPHeaders? = nil, loggingEnabled: Bool = false) {
    self.sessionManager = sessionManager
    self.url = url
    self.headers = headers
    self.loggingEnabled = loggingEnabled
  }

  func send<Operation>(operation: Operation,
  completionHandler: @escaping (GraphQLResponse<Operation>?, Error?) -> Void)
  -> Cancellable where Operation: GraphQLOperation {
    let vars = operation.variables?.mapValues { $0?.jsonValue } as Any
    let body = ["query": type(of: operation).requestString, "variables": vars]
    let request = sessionManager
      .request(url, method: .post, parameters: body,
               encoding: JSONEncoding.default, headers: headers)
      .validate(statusCode: [200])
    if loggingEnabled {
    debugPrint(request)
    }
    return request.responseJSON { response in
      let gqlResult = response.result
        .flatMap { value -> GraphQLResponse<Operation> in
          guard let value = value as? JSONObject else {
            throw response.error!
          }
          if self.loggingEnabled, let data = response.data {
            print(String(data: data, encoding: .utf8))
          }
          return GraphQLResponse(operation: operation, body: value)
      }
      completionHandler(gqlResult.value, gqlResult.error)
    }.task!
  }
}
