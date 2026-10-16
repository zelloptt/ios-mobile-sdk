#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import ZelloSecure
#endif
import Zello3rdPartyDependenciesConfigurationObjC

final class AesKeyBuilder: NSObject, AesKeyBuildable {
    func build(with key: Data) -> AesKey? {
        AesKeyImpl(dataKey: key)
    }

    func generateNewKey() -> AesKey? {
        guard let newKey = Crypto.instance().generateAesKeyData() else {
            return nil
        }

        return build(with: newKey)
    }
}
