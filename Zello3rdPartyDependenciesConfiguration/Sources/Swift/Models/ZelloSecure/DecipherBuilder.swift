import ZelloSecure
import Zello3rdPartyDependenciesConfigurationObjC

final class DecipherBuilder: NSObject, DecipherBuildable {
  func build() -> Decipher {
    DecipherImpl()
  }
}
