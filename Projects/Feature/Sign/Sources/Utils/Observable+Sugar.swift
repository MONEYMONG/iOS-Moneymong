import RxSwift

extension Observable {
  static func task<T>(type: T.Type, _ c: @escaping () async throws -> T) -> Observable<T> {
    return Single<T>.create { single in
      Task {
        do {
          let v = try await c()
          single(.success(v))
        } catch {
          single(.failure(error))
        }
      }
      return Disposables.create()
    }
    .asObservable()
  }
}
