enum Config {
#if DEBUG
  static let base = "https://dev.moneymong.site/api/"
#else
  static let base = "https://prod.moneymong.site/api/"
#endif
}
