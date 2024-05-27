import NetworkService

struct LedgerImageInfo: Equatable {
  let imageSection: LedgerContentsReactor.ImageSection
  let key: String
  let url: String

  init(imageSection: LedgerContentsReactor.ImageSection, key: String, url: String) {
    self.imageSection = imageSection
    self.key = key
    self.url = url
  }

  var toEntity: ImageInfo { .init(key: key, url: url) }
}
