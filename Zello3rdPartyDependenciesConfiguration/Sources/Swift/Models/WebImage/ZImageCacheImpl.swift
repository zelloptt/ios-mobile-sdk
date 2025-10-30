import SDWebImage
import Foundation
import Utility

final class ZImageCacheImpl: ZImageCache {
  var totalDiskSize: UInt {
    SDImageCache.shared.totalDiskSize()
  }

  var config: Utility.ZImageCacheConfig? {
    didSet {
      guard let config else {
        return
      }

      SDImageCache.shared.config.maxDiskAge = config.maxDiskAge
      SDImageCache.shared.config.maxMemoryCost = config.maxMemoryCost
      SDImageCache.shared.config.shouldCacheImagesInMemory = config.shouldCacheImagesInMemory
      SDImageCache.shared.config.diskCacheReadingOptions = config.diskCacheReadingOptions
    }
  }

  func clearDisk(completion: Utility.ZNoParamsBlock?) {
    SDImageCache.shared.clearDisk(onCompletion: completion)
  }

  func clearMemory() {
    SDImageCache.shared.clearMemory()
  }

  func image(for key: String?) -> UIImage? {
    SDImageCache.shared.imageFromCache(forKey: key)
  }

  func store(_ image: UIImage?, for key: String?, completion: ZNoParamsBlock?) {
    SDImageCache.shared.store(image, forKey: key, completion: completion)
  }

  func store(_ image: UIImage?, for key: String?, toDisk: Bool, completion: ZNoParamsBlock?) {
    SDImageCache.shared.store(image, forKey: key, toDisk: toDisk, completion: completion)
  }

  func removeImage(for key: String?, completion: Utility.ZNoParamsBlock?) {
    SDImageCache.shared.removeImage(forKey: key, withCompletion: completion)
  }

  func removeImage(for key: String?, fromDisk: Bool, completion: ZNoParamsBlock?) {
    SDImageCache.shared.removeImage(forKey: key, fromDisk: fromDisk, withCompletion: completion)
  }

  func imageTimestamp(for key: String) -> TimeInterval {
    guard let cachedPath = SDImageCache.shared.cachePath(forKey: key) else {
      return 0
    }
    let attributes = try? FileManager.default.attributesOfItem(atPath: cachedPath)
    let creationDate = attributes?[.creationDate] as? Date
    return creationDate?.timeIntervalSince1970 ?? 0
  }

  func diskImageDataExists(for key: String?) -> Bool {
    SDImageCache.shared.diskImageDataExists(withKey: key)
  }
}
