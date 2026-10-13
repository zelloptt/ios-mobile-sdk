#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import ZelloSecure
#endif
import Zello3rdPartyDependenciesConfigurationObjC

final class RsaKeyPublicBuilder: NSObject, RsaKeyPublicBuildable {
    func build() -> RsaKeyPublic {
        RsaKeyPublicImpl()
    }
}
