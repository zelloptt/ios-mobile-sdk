import ZelloSecure
import Zello3rdPartyDependenciesConfigurationObjC

final class DecipherBuilder: NSObject, DecipherBuildable {
    func build(with key: AesKey) -> Decipher? {
        DecipherImpl(key: key)
    }
}
