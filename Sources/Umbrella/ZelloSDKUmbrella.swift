@_exported import ZelloSDK
import Zello3rdPartyDependenciesConfiguration

/// Static reference that forces the linker to pull in the compiled object
/// file produced from `Zello3rdPartyAutoInstallRetainer.swift` at customer
/// link time. That object file contains references to the ObjC `+load`
/// autoinstaller classes (e.g. `ZelloCLJAutoInstall.self`), which keeps the
/// linker from dead-stripping those classes in customer apps that build
/// without `-ObjC`. With the classes retained, their `+load` methods run at
/// dyld image-load time and install the third-party adapters.
@_used
private let _zelloAutoInstallRetainerAnchor: () -> Void = Zello3rdPartyAutoInstallRetainer.retain
