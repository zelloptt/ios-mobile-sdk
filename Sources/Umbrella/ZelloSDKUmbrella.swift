@_exported import ZelloSDK
import Zello3rdPartyDependenciesConfiguration

/// Forces the linker to pull the ObjC `+load` autoinstaller object files
/// (e.g. `ZelloCLJAutoInstall`) into this umbrella framework. The umbrella
/// ships as a `.dynamic` product, so dyld loads it at launch and runs those
/// `+load` methods, which replace the dummy `fatalError` adapters in
/// `UtilityThirdPartySupport` before `Zello.shared` first touches them.
///
/// Dynamic linkage guarantees the umbrella *image* loads; this reference
/// guarantees the autoinstaller classes are *inside* that image — the linker
/// keeps an object file only if something references it, and nothing else
/// references the standalone `+load` classes.
///
/// Implemented as an exported `@_cdecl` function rather than `@_used`: a
/// C-linkage export is an unconditional dead-strip root, so it survives
/// without the experimental `SymbolLinkageMarkers` feature that `@_used`
/// requires. Customer-side SPM builds do not enable that feature, so `@_used`
/// here was a hard compile error for every SPM consumer. The function is not
/// meant to be called; its body's reference to the retainer is what pulls the
/// autoinstaller object files into the link.
@_cdecl("ZelloRetainThirdPartyAutoInstallers")
public func zelloRetainThirdPartyAutoInstallers() {
    Zello3rdPartyAutoInstallRetainer.retain()
}
