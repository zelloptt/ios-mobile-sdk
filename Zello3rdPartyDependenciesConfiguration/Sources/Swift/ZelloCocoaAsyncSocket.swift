import Utility

@_cdecl("ZelloCocoaAsyncSocketConfigurationInstall")
// swiftlint:disable:next identifier_name
public func ZelloCocoaAsyncSocketConfigurationInstall() {
  UtilityThirdPartySupport.zAsyncSocketBuilder = ZAsyncSocketBuilder()
  UtilityThirdPartySupport.zAsyncUdpSocketBuilder = ZAsyncUdpSocketBuilder()
}
