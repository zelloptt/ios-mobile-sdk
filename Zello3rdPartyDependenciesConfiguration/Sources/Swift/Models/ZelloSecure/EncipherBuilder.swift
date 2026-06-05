import ZelloSecure
import Zello3rdPartyDependenciesConfigurationObjC

final class EncipherBuilder: NSObject, EncipherBuildable {
    func build() -> Encipher {
        EncipherImpl()
    }
}
