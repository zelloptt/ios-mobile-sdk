import SDWebImage
import Foundation
import Utility

final class ZImageManagerImpl: ZImageManager {
  var optionsProcessorType: ZImageOptionsProcessorType = .none {
    didSet {
      SDWebImageManager.shared.optionsProcessor = optionsProcessorType.asSDWebImageOptionsProcessor
    }
  }

  func loadImage(
    with url: URL?,
    options: ZWebImageOptions,
    progress: ZImageLoaderProgressBlock?,
    completed: ZImageLoaderCompletionBlock?
  ) {
    SDWebImageManager.shared.loadImage(
      with: url,
      options: options.asSDWebImageOptions,
      progress: { receivedSize, expectedSize, targetURL in
        progress?(receivedSize, expectedSize, targetURL)
      },
      completed: { image, data, error, cacheType, finished, imageURL in
        completed?(image, data, error, cacheType.asZImageCacheType, finished, imageURL)
      })
  }
}

fileprivate extension ZImageOptionsProcessorType {
  var asSDWebImageOptionsProcessor: SDWebImageOptionsProcessor? {
    switch self {
    case .none:
      nil
    case .disableForceDecode:
      SDWebImageOptionsProcessor(block: { _, options, context in
        var mutableContext: [SDWebImageContextOption: Any] = context ?? [:]
        mutableContext[SDWebImageContextOption.imageForceDecodePolicy] = SDImageForceDecodePolicy.never.rawValue
        return SDWebImageOptionsResult(options: options, context: mutableContext)
      })
    @unknown default:
      fatalError("We need to handle all ZImageOptionsProcessorType cases")
    }
  }
}
