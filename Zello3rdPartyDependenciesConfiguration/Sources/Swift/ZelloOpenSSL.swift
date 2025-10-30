import ZelloSecure

@_cdecl("ZelloOpenSSLConfigurationInstall")
// swiftlint:disable:next identifier_name
public func ZelloOpenSSLConfigurationInstall() {
  ZelloSecureThirdPartySupport.aesKeyBuilder = AesKeyBuilder()
  ZelloSecureThirdPartySupport.decipherBuilder = DecipherBuilder()
  ZelloSecureThirdPartySupport.encipherBuilder = EncipherBuilder()
  ZelloSecureThirdPartySupport.rsaKeyPublicBuilder = RsaKeyPublicBuilder()
  ZelloSecureThirdPartySupport.rsaKeyPrivateBuilder = RsaKeyPrivateBuilder()
  ZelloSecureThirdPartySupport.rsaKeyPairBuilder = RsaKeyPairBuilder()
}
