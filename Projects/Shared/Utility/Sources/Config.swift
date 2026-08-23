public enum Config {
#if DEBUG
  public static let base = "https://dev.moneymong.site/api/"
#else
  public static let base = "https://prod.moneymong.site/api/"
#endif
}
