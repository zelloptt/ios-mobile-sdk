import SDWebImage
import Foundation
import Utility

final class ZImageDownloaderImpl: ZImageDownloader {
    func downloadImage(with url: URL?, completed: @escaping ZImageLoaderCompletedBlock) {
        SDWebImageDownloader.shared.downloadImage(with: url, completed: completed)
    }
}
