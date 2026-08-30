//
//  MockUserRepository.swift
//  BaseDomain
//
//  Created by 이시원 on 5/30/26.
//

import Foundation

import BaseDomain

public class MockUserRepository: UserRepositoryInterface {
  public struct CallCount {
    public var user = 0
    public var fetchUserID = 0
    public var fetchSelectedAgency = 0
    public var updateSelectedAgency = 0
    public var logout = 0
    public var withdrawl = 0
  }

  public struct ReturnValue {
    public var user: BaseDomain.UserInfo?
    public var fetchUserID: Int = 0
    public var fetchSelectedAgency: Int?
  }

  public struct InputValue {
    public var updateSelectedAgency: Int?? = nil
  }

  public var callCount: CallCount = .init()
  public var returnValue: ReturnValue = .init()
  public var inputValue: InputValue = .init()

  public init() {}

  public func user() async throws -> BaseDomain.UserInfo {
    callCount.user += 1
    return returnValue.user!
  }

  public func fetchUserID() -> Int {
    callCount.fetchUserID += 1
    return returnValue.fetchUserID
  }

  public func fetchSelectedAgency() -> Int? {
    callCount.fetchSelectedAgency += 1
    return returnValue.fetchSelectedAgency
  }

  public func updateSelectedAgency(id: Int?) {
    callCount.updateSelectedAgency += 1
    inputValue.updateSelectedAgency = id
  }

  public func logout() async throws {
    callCount.logout += 1
  }

  public func withdrawl() async throws {
    callCount.withdrawl += 1
  }
}
