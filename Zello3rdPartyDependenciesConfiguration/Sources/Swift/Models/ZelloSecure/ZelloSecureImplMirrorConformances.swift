#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
import Zello3rdPartyDependenciesConfigurationObjC

// In the distribution shape the crypto protocol names in the builder files
// (AesKey, Decipher, ...) resolve to the ZelloSDK SPI mirrors, while the ObjC
// impl classes still conform to the ObjC protocols that reach this target
// through Zello3rdPartyDependenciesConfigurationObjC. These extensions add the
// mirror conformances so the shared builder bodies compile unchanged.
//
// Members whose ObjC signatures reference the ObjC crypto protocols
// (EncipherImpl.setKey, DecipherImpl/RsaKeyPairImpl inits, RsaKeyPairImpl
// accessors) get mirror-typed fronts that bridge with runtime casts: every
// mirror value that reaches the glue is either a round-trip-unwrapped impl
// object or a ZelloSDK wrapper that also conforms to the ObjC protocol, so the
// forced casts hold (ObjC protocol identity is by name at runtime).

// Module-scope typealiases: the vendored clang protocols (via the ObjC
// target) and the ZelloSDK mirrors both declare these names — a local
// typealias wins name lookup, so the shared builder bodies stay unambiguous.
typealias AesKey = ZelloSDK.AesKey
typealias Decipher = ZelloSDK.Decipher
typealias Encipher = ZelloSDK.Encipher
typealias RsaKeyPublic = ZelloSDK.RsaKeyPublic
typealias RsaKeyPrivate = ZelloSDK.RsaKeyPrivate
typealias RsaKeyPair = ZelloSDK.RsaKeyPair

@_spi(ThirdPartyBootstrap) extension AesKeyImpl: ZelloSDK.AesKey {}

@_spi(ThirdPartyBootstrap) extension RsaKeyPublicImpl: ZelloSDK.RsaKeyPublic {}

@_spi(ThirdPartyBootstrap) extension RsaKeyPrivateImpl: ZelloSDK.RsaKeyPrivate {}

@_spi(ThirdPartyBootstrap) extension DecipherImpl: ZelloSDK.Decipher {
    @nonobjc public convenience init?(key: ZelloSDK.AesKey) {
        // swiftlint:disable:next force_cast
        self.init(key: key as! Zello3rdPartyDependenciesConfigurationObjC.AesKey)
    }
}

@_spi(ThirdPartyBootstrap) extension EncipherImpl: ZelloSDK.Encipher {
    @nonobjc public func setKey(_ key: ZelloSDK.AesKey) {
        // swiftlint:disable:next force_cast
        setKey(key as! Zello3rdPartyDependenciesConfigurationObjC.AesKey)
    }
}

@_spi(ThirdPartyBootstrap) extension RsaKeyPairImpl: ZelloSDK.RsaKeyPair {
    @nonobjc public convenience init(publicKey: ZelloSDK.RsaKeyPublic, privateKey: ZelloSDK.RsaKeyPrivate) {
        self.init(
            // swiftlint:disable:next force_cast
            publicKey: publicKey as! Zello3rdPartyDependenciesConfigurationObjC.RsaKeyPublic,
            // swiftlint:disable:next force_cast
            privateKey: privateKey as! Zello3rdPartyDependenciesConfigurationObjC.RsaKeyPrivate
        )
    }

    @nonobjc public func getKeyPublic() -> ZelloSDK.RsaKeyPublic? {
        let real: (any Zello3rdPartyDependenciesConfigurationObjC.RsaKeyPublic)? = getKeyPublic()
        // swiftlint:disable:next force_cast
        return real.map { $0 as! ZelloSDK.RsaKeyPublic }
    }

    @nonobjc public func getKeyPrivate() -> ZelloSDK.RsaKeyPrivate? {
        let real: (any Zello3rdPartyDependenciesConfigurationObjC.RsaKeyPrivate)? = getKeyPrivate()
        // swiftlint:disable:next force_cast
        return real.map { $0 as! ZelloSDK.RsaKeyPrivate }
    }
}
#endif
