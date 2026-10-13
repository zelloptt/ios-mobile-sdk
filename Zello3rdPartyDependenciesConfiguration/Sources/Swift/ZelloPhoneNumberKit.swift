import PhoneNumberKit
#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import Utility
#endif

@_cdecl("ZelloPhoneNumberConfigurationInstall")
// swiftlint:disable:next identifier_name
public func ZelloPhoneNumberConfigurationInstall() {
    UtilityThirdPartySupport.zelloPhoneNumberKit = PhoneNumberUtility()
}
