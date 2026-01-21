import ZelloSecure
import Zello3rdPartyDependenciesConfigurationObjC

final class RsaKeyPairBuilder: NSObject, RsaKeyPairBuildable {
  func build() -> RsaKeyPair {
    RsaKeyPairImpl()
  }

  func build(with bitSize: Int) -> RsaKeyPair {
    RsaKeyPairImpl(bitSize: bitSize)
  }

  func build(with publicKey: RsaKeyPublic, privateKey: RsaKeyPrivate) -> RsaKeyPair {
    RsaKeyPairImpl(publicKey: publicKey, privateKey: privateKey)
  }
}
