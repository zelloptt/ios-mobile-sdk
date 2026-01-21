import SDWebImage
import Utility

@_cdecl("ZelloSDWebImageConfigurationInstall")
// swiftlint:disable:next identifier_name
public func ZelloSDWebImageConfigurationInstall() {
  UtilityThirdPartySupport.zelloImageCache = ZImageCacheImpl()
  UtilityThirdPartySupport.zelloImageManager = ZImageManagerImpl()
  UtilityThirdPartySupport.zelloImageDownloader = ZImageDownloaderImpl()
  UtilityThirdPartySupport.zelloImageViewLoading = ZImageViewLoadingImpl()
}
