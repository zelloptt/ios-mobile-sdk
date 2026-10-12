import SDWebImage
#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import Utility
#endif

@_cdecl("ZelloSDWebImageConfigurationInstall")
// swiftlint:disable:next identifier_name
public func ZelloSDWebImageConfigurationInstall() {
    UtilityThirdPartySupport.zelloImageCache = ZImageCacheImpl()
    UtilityThirdPartySupport.zelloImageManager = ZImageManagerImpl()
    UtilityThirdPartySupport.zelloImageDownloader = ZImageDownloaderImpl()
    UtilityThirdPartySupport.zelloImageViewLoading = ZImageViewLoadingImpl()
}
