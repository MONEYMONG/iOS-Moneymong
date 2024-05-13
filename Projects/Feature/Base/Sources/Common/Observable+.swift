import RxSwift

public extension Observable {
  static func task<T>(@_implicitSelfCapture _ c: @escaping () async throws -> T) -> Observable<T> {
    return Single<T>.create { single in
      let task = Task {
        do {
          let result = try await c()
          single(.success(result))
        } catch {
          single(.failure(error))
        }
      }
      return Disposables.create {
        task.cancel()
      }
    }
    .asObservable()
  }
}
