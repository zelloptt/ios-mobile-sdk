import PhoneNumberKit
import Utility

@_cdecl("ZelloPhoneNumberConfigurationInstall")
// swiftlint:disable:next identifier_name
public func ZelloPhoneNumberConfigurationInstall() {
  UtilityThirdPartySupport.zelloPhoneNumberKit = PhoneNumberKit()
}
