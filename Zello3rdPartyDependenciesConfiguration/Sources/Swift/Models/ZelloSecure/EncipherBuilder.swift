#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import ZelloSecure
#endif
import Zello3rdPartyDependenciesConfigurationObjC

final class EncipherBuilder: NSObject, EncipherBuildable {
    func build() -> Encipher {
        EncipherImpl()
    }
}
