//
//  ReportReactor.swift
//  LedgerFeature
//
//  Created by 이시원 on 6/2/26.
//

import Foundation

import BaseDomain
import BaseFeature
import LedgerInterface
import Utility

import ReactorKit

final class ReportReactor: Reactor {
  enum Action {
    case requestReport
    case changeSegment(Int)
    case changePageIndex(Int)
  }
  
  enum Mutation {
    case setReport(Report)
    case setIndex(Int)
    case setError(MoneyMongError)
    case setLoading(Bool)
    case setSegmentIndex(Int)
  }
  
  struct State {
    @Pulse var agencyId: Int
    @Pulse var report: Report?
    @Pulse var reportItem: ReportItem?
    @Pulse var pageIndex: Int = -1
    @Pulse var currentMonthly: MonthlyReportItem?
    @Pulse var memberReports: [MemberReportItem] = []
    @Pulse var categoryReports: [CategoryReportItem] = []
    @Pulse var error: MoneyMongError?
    @Pulse var isLoading = false
    @Pulse var segmentIndex: Int = 0
    @Pulse var isShownMonthlyProgress: Bool = false
    @Pulse var isRightButtonEnabled: Bool = false
  }
  
  let initialState: State
  let formatter: ContentFormatter

  private let getReportUseCase: GetReportUseCaseInterface
  
  init(
    agencyId: Int,
    getReportUseCase: GetReportUseCaseInterface = DIContainer.shared.resolve(type: GetReportUseCaseInterface.self),
    formatter: ContentFormatter = DIContainer.shared.resolve(type: ContentFormatter.self),
  ) {
    self.initialState = State(agencyId: agencyId)
    self.getReportUseCase = getReportUseCase
    self.formatter = formatter
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestReport:
      return Observable.concat([
        .just(.setLoading(true)),
        requestReport(),
        .just(.setLoading(false))
      ])
    case .changeSegment(let index):
      return .just(.setSegmentIndex(index))
    case .changePageIndex(let value):
      let newPageIndex = currentState.pageIndex + value
      if !currentState.isLoading, newPageIndex < 1 {
        return Observable.concat([
          .just(.setIndex(newPageIndex)),
          .just(.setLoading(true)),
          requestReport(),
          .just(.setLoading(false))
        ])
      } else {
        return .just(.setIndex(newPageIndex))
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.isShownMonthlyProgress = false
    switch mutation {
    case .setReport(let report):
      newState.report = report
      newState.reportItem = ReportItem(report: report, formatter: formatter)
     
    case .setIndex(let i):
      guard let report = state.report else { return newState }
      newState.pageIndex = i
      
      // index가 -1인 경우 => 프로그레스뷰 & left버튼 disable
      if i < 0 {
        newState.isShownMonthlyProgress = true
        return newState
      }
      
      let currentMonthly = MonthlyReportItem(monthly: report.monthly[i], formatter: formatter)
      newState.currentMonthly = currentMonthly
      newState.memberReports = currentMonthly.members
      newState.categoryReports = currentMonthly.categories
      newState.isRightButtonEnabled = !(i == report.monthly.count - 1)

      
    case .setError(let error):
      newState.error = error
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    case .setSegmentIndex(let index):
      newState.segmentIndex = index
    }
    return newState
  }
  
  private func requestReport() -> Observable<Mutation> {
    return .task {
      try await getReportUseCase.execute(
        agencyID: currentState.agencyId,
        report: currentState.report,
        currentDate: .now,
        limit: 3
      )
    }.flatMap { [weak self] report in
      guard let self else { return Observable<Mutation>.empty() }
      return Observable<Mutation>.concat([
        .just(.setReport(report)),
        .just(.setIndex(currentState.pageIndex + (report.monthly.count - (currentState.report?.monthly.count ?? 0))))
      ])
    }.catch { return .just(.setError($0.toMMError)) }
  }
}

