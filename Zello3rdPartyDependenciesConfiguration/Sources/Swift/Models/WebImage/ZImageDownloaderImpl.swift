import SDWebImage
import Foundation
#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import Utility
#endif

final class ZImageDownloaderImpl: ZImageDownloader {
    func downloadImage(with url: URL?, completed: @escaping ZImageLoaderCompletedBlock) {
        SDWebImageDownloader.shared.downloadImage(with: url, completed: completed)
    }
}
