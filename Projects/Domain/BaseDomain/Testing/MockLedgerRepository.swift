//
//  MockLedgerRepository.swift
//  BaseDomain
//
//  Created by 이시원 on 5/30/26.
//

import Foundation

import BaseDomain

public class MockLedgerRepository: LedgerRepositoryInterface {
  public struct CallCount {
    public var imageUpload = 0
    public var imageDelete = 0
    public var fetchLedgerDetail = 0
    public var create = 0
    public var update = 0
    public var delete = 0
    public var fetchLedgerList = 0
    public var documentImagesUpload = 0
    public var documentImageDelete = 0
    public var saveDateRange = 0
    public var fetchDateRange = 0
    public var fetchReport = 0
  }
  
  public struct ReturnValue {
    public var imageUpload: BaseDomain.ImageInfo?
    public var fetchLedgerDetail: BaseDomain.LedgerDetail?
    public var update: BaseDomain.LedgerDetail?
    public var fetchLedgerList: BaseDomain.LedgerList?
    public var fetchDateRange: BaseDomain.DateRange?
    public var fetchReport: BaseDomain.Report?
  }
  
  public struct InputValue {
    public var imageUpload: Data? = nil
    public var imageDelete: ImageInfo? = nil
    public var fetchLedgerDetail: Int? = nil
    public var create: (
      id: Int,
      storeInfo: String,
      fundType: BaseDomain.FundType,
      amount: Int,
      description: String,
      paymentDate: String,
      documentImageUrls: [String],
      category: String?
    )? = nil
    public var update: LedgerDetail? = nil
    public var delete: Int? = nil
    public var fetchLedgerList: (
      id: Int,
      start: BaseDomain.DateInfo,
      end: BaseDomain.DateInfo,
      page: Int,
      limit: Int,
      fundType: BaseDomain.FundType?
    )? = nil
    public var documentImagesUpload: (
      detailId: Int,
      documentImageUrls: [String]
    )? = nil
    public var documentImageDelete: (
      detailId: Int,
      documentId: Int
    )? = nil
    public var saveDateRange: DateRange? = nil
    public var fetchReport: (
      agencyID: Int,
      from: Date,
      to: Date
    )? = nil
  }
  
  public var callCount: CallCount = .init()
  public var returnValue: ReturnValue = .init()
  public var inputValue: InputValue = .init()
  
  public init() {}
  
  public func imageUpload(_ data: Data) async throws -> BaseDomain.ImageInfo {
    callCount.imageUpload += 1
    inputValue.imageUpload = data
    return returnValue.imageUpload!
  }
  
  public func imageDelete(_ image: BaseDomain.ImageInfo) async throws {
    callCount.imageDelete += 1
    inputValue.imageDelete = image
  }
  
  public func fetchLedgerDetail(id: Int) async throws -> BaseDomain.LedgerDetail {
    callCount.fetchLedgerDetail += 1
    inputValue.fetchLedgerDetail = id
    return returnValue.fetchLedgerDetail!
  }
  
  public func create(
    id: Int,
    storeInfo: String,
    fundType: BaseDomain.FundType,
    amount: Int,
    description: String,
    paymentDate: String,
    documentImageUrls: [String],
    category: String?
  ) async throws {
    callCount.create += 1
    inputValue.create = (
      id: id,
      storeInfo: storeInfo,
      fundType: fundType,
      amount: amount,
      description: description,
      paymentDate: paymentDate,
      documentImageUrls: documentImageUrls,
      category: category
    )
  }
  
  public func update(ledger: BaseDomain.LedgerDetail) async throws -> BaseDomain.LedgerDetail {
    callCount.update += 1
    inputValue.update = ledger
    return returnValue.update!
  }
  
  public func delete(id: Int) async throws {
    callCount.delete += 1
    inputValue.delete = id
  }
  
  public func fetchLedgerList(
    id: Int,
    start: BaseDomain.DateInfo,
    end: BaseDomain.DateInfo,
    page: Int,
    limit: Int,
    fundType: BaseDomain.FundType?
  ) async throws -> BaseDomain.LedgerList {
    callCount.fetchLedgerList += 1
    inputValue.fetchLedgerList = (
      id: id,
      start: start,
      end: end,
      page: page,
      limit: limit,
      fundType: fundType
    )
    return returnValue.fetchLedgerList!
  }
  
  public func documentImagesUpload(detailId: Int, documentImageUrls: [String]) async throws {
    callCount.documentImagesUpload += 1
    inputValue.documentImagesUpload = (detailId: detailId, documentImageUrls: documentImageUrls)
  }
  
  public func documentImageDelete(detailId: Int, documentId: Int) async throws {
    callCount.documentImageDelete += 1
    inputValue.documentImageDelete = (detailId: detailId, documentId: documentId)
  }
  
  public func saveDateRange(_ dateRange: BaseDomain.DateRange) {
    callCount.saveDateRange += 1
    inputValue.saveDateRange = dateRange
  }
  
  public func fetchDateRange() -> BaseDomain.DateRange? {
    callCount.fetchDateRange += 1
    return returnValue.fetchDateRange!
  }
  
  public func fetchReport(agencyID: Int, from: Date, to: Date) async throws -> BaseDomain.Report {
    callCount.fetchReport += 1
    inputValue.fetchReport = (agencyID: agencyID, from: from, to: to)
    return returnValue.fetchReport!
  }
}
