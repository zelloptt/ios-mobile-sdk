import ZelloSecure
import Zello3rdPartyDependenciesConfigurationObjC

final class RsaKeyPublicBuilder: NSObject, RsaKeyPublicBuildable {
    func build() -> RsaKeyPublic {
        RsaKeyPublicImpl()
    }
}
