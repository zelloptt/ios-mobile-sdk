import UIKit
import Utility
import SDWebImage

final class ZImageViewLoadingImpl: ZImageViewLoading {
    public func setImage(
        for imageView: UIImageView,
        with url: URL?,
        placeholderImage placeholder: UIImage?,
        options: ZWebImageOptions,
        completed: ZCompletionBlock?
    ) {
        imageView.sd_setImage(with: url, placeholderImage: placeholder, options: options.asSDWebImageOptions) { image, error, cacheType, url in
            completed?(image, error, cacheType.asZImageCacheType, url)
        }
    }

    public func cancelCurrentImageLoad(
        for imageView: UIImageView
    ) {
        imageView.sd_cancelCurrentImageLoad()
    }
}
