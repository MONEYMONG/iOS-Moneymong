import BaseDomain

struct LedgerImageInfo: Equatable {
  let key: String
  let url: String

  init(key: String, url: String) {
    self.key = key
    self.url = url
  }

  var toEntity: ImageInfo { .init(key: key, url: url) }
}
