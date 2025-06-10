import Foundation

import MMNetworkInterface

public final class MemoryCache: Cacheable {
  private let cache = NSCache<NSString, NSData>()
    
  public init(totalCostLimit: Int) {
    cache.totalCostLimit = totalCostLimit
  }
  
  public convenience init(memoryPercent: Double = 0.05) {
    self.init(totalCostLimit: Int(Double(ProcessInfo.processInfo.physicalMemory) * memoryPercent))
  }
  
  public func save(data: Data, key: String) {
    cache.setObject(data as NSData, forKey: key as NSString)
  }
  
  public func delete(key: String) {
    cache.removeObject(forKey: key as NSString)
  }
  
  public func read(key: String) -> Data? {
    return cache.object(forKey: key as NSString) as? Data
  }
  
  public func deleteAll() {
    cache.removeAllObjects()
  }
}
