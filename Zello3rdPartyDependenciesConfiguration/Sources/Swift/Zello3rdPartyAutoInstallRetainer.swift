import Zello3rdPartyDependenciesConfigurationObjC

/// Forces the linker to retain the ObjC `+load` autoinstaller classes from
/// `Zello3rdPartyDependenciesConfigurationObjC` in customer apps that link
/// the SDK as a static library (the SwiftPM source-target distribution path).
///
/// Without these references, the autoinstaller classes have no other call
/// sites and would be dead-stripped at customer link time when `-ObjC` is
/// not set. Stripped classes never have their `+load` methods invoked, which
/// leaves the dummy `fatalError` adapters in `UtilityThirdPartySupport`
/// installed and crashes on first use.
///
/// This file is only compiled in the SwiftPM distribution path. The in-house
/// Zello.app build (xcodegen) excludes this file because the in-house build
/// links `Zello3rdPartyDependenciesConfigurationObjC` as a dynamic framework
/// where dyld loads `+load` classes regardless of dead-strip rules.
public enum Zello3rdPartyAutoInstallRetainer {
    /// Stored property whose initializer materializes each class metatype
    /// into an array. Lazy static initialization is an observable
    /// side effect (writes module-global storage), so the optimizer cannot
    /// dead-strip the array's element loads — every `OBJC_CLASS_$_…` symbol
    /// is referenced from this object file and survives `-O` and customer
    /// dead-strip.
    private static let pinned: [AnyClass] = [
        ZelloCLJAutoInstall.self,
        SnowplowAnalyticsProxyAutoInstall.self,
        ZelloSDWebImageAutoInstall.self,
        ZelloOpenSSLAutoInstall.self,
        ZelloPhoneNumberKitAutoInstall.self
    ]

    /// Forces evaluation of `pinned` (and therefore the class symbol
    /// references it captures). The customer-side umbrella target calls
    /// this so the linker keeps the `+load` classes alive in the final
    /// binary.
    @inline(never)
    public static func retain() {
        _ = pinned.count
    }
}
