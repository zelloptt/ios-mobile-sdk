import ZelloSecure
import Zello3rdPartyDependenciesConfigurationObjC

final class RsaKeyPrivateBuilder: NSObject, RsaKeyPrivateBuildable {
    func build() -> RsaKeyPrivate {
        RsaKeyPrivateImpl()
    }
}
