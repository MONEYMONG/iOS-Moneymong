//
//  MockAgencyRepository.swift
//  BaseDomain
//
//  Created by 이시원 on 5/30/26.
//

import Foundation

import BaseDomain

public class MockAgencyRepository: AgencyRepositoryInterface {
  public struct CallCount {
    public var create = 0
    public var fetchMemberList = 0
    public var changeMemberRole = 0
    public var kickoutMember = 0
    public var fetchMyAgency = 0
    public var fetchCode = 0
    public var certificateCode = 0
    public var reissueCode = 0
    public var deleteAgency = 0
    public var getCategories = 0
    public var createCategory = 0
    public var deleteCategory = 0
  }

  public struct ReturnValue {
    public var create: Int?
    public var fetchMemberList: [BaseDomain.Member]?
    public var fetchMyAgency: [BaseDomain.Agency]?
    public var fetchCode: String?
    public var certificateCode: BaseDomain.CertificationResult?
    public var reissueCode: String?
    public var getCategories: [BaseDomain.MMCategory]?
  }

  public struct InputValue {
    public var create: String? = nil
    public var fetchMemberList: Int? = nil
    public var changeMemberRole: (id: Int, userId: Int, role: String)? = nil
    public var kickoutMember: (id: Int, userId: Int)? = nil
    public var fetchCode: Int? = nil
    public var certificateCode: String? = nil
    public var reissueCode: Int? = nil
    public var deleteAgency: Int? = nil
    public var getCategories: Int? = nil
    public var createCategory: (agencyId: Int, name: String)? = nil
    public var deleteCategory: Int? = nil
  }

  public var callCount: CallCount = .init()
  public var returnValue: ReturnValue = .init()
  public var inputValue: InputValue = .init()

  public init() {}

  public func create(name: String) async throws -> Int {
    callCount.create += 1
    inputValue.create = name
    return returnValue.create!
  }

  public func fetchMemberList(id: Int) async throws -> [BaseDomain.Member] {
    callCount.fetchMemberList += 1
    inputValue.fetchMemberList = id
    return returnValue.fetchMemberList!
  }

  public func changeMemberRole(id: Int, userId: Int, role: String) async throws {
    callCount.changeMemberRole += 1
    inputValue.changeMemberRole = (id: id, userId: userId, role: role)
  }

  public func kickoutMember(id: Int, userId: Int) async throws {
    callCount.kickoutMember += 1
    inputValue.kickoutMember = (id: id, userId: userId)
  }

  public func fetchMyAgency() async throws -> [BaseDomain.Agency] {
    callCount.fetchMyAgency += 1
    return returnValue.fetchMyAgency!
  }

  public func fetchCode(id: Int) async throws -> String {
    callCount.fetchCode += 1
    inputValue.fetchCode = id
    return returnValue.fetchCode!
  }

  public func certificateCode(code: String) async throws -> BaseDomain.CertificationResult {
    callCount.certificateCode += 1
    inputValue.certificateCode = code
    return returnValue.certificateCode!
  }

  public func reissueCode(id: Int) async throws -> String {
    callCount.reissueCode += 1
    inputValue.reissueCode = id
    return returnValue.reissueCode!
  }

  public func deleteAgency(id: Int) async throws {
    callCount.deleteAgency += 1
    inputValue.deleteAgency = id
  }

  public func getCategories(id: Int) async throws -> [BaseDomain.MMCategory] {
    callCount.getCategories += 1
    inputValue.getCategories = id
    return returnValue.getCategories!
  }

  public func createCategory(agencyId: Int, name: String) async throws {
    callCount.createCategory += 1
    inputValue.createCategory = (agencyId: agencyId, name: name)
  }

  public func deleteCategory(id: Int) async throws {
    callCount.deleteCategory += 1
    inputValue.deleteCategory = id
  }
}
