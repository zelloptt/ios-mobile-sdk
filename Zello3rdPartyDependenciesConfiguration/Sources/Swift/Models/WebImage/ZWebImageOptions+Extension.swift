#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import Utility
#endif
import SDWebImage

extension ZWebImageOptions {
    var asSDWebImageOptions: SDWebImageOptions {
        SDWebImageOptions(rawValue: rawValue)
    }
}
