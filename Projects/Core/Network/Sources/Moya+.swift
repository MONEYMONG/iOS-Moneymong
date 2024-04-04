//
//  Moya+.swift
//  Network
//
//  Created by 김동욱 on 4/4/24.
//

import Foundation

public extension MoyaProvider {
  func request(target: Target) async -> Result<Response, MoyaError> {
    await withCheckedContinuation { continuation in
      self.request(target) { result in
        continuation.resume(returning: result)
      }
    }
  }
}
