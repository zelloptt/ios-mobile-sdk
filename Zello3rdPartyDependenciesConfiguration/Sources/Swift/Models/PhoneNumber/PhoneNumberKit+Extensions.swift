import PhoneNumberKit
#if ZELLO_SDK_DISTRIBUTION
@_spi(ThirdPartyBootstrap) import ZelloSDK
#else
import Utility
#endif

@_spi(ThirdPartyBootstrap) extension PhoneNumberUtility: @retroactive ZelloPhoneNumberKit {
    public func format(_ phoneNumber: ZPhoneNumber, toType formatType: ZPhoneNumberFormat, withPrefix prefix: Bool) -> String {
        let regionID = phoneNumber.regionID ?? PhoneNumberUtility.defaultRegionCode()
        guard let parsedPhoneNumber = try? parse(phoneNumber.numberString, withRegion: regionID) else {
            fatalError("This should never happen as this logic is mainly to convert Utility.PhoneNumber into PhoneNumberKit.PhoneNumber")
        }
        return format(parsedPhoneNumber, toType: formatType.asPhoneNumberFormat, withPrefix: prefix)
    }

    public func parse(_ numberString: String, withRegion region: String, ignoreType: Bool) throws -> ZPhoneNumber {
        try parse(numberString, withRegion: region, ignoreType: ignoreType).asZPhoneNumber
    }

    /// Explicit witness: PhoneNumberKit 5 adds a defaulted `ignorePrefixValidation:` parameter to its own
    /// `isValidPhoneNumber`, which stops it from satisfying the three-parameter protocol requirement.
    public func isValidPhoneNumber(_ numberString: String, withRegion region: String, ignoreType: Bool) -> Bool {
        (try? parse(numberString, withRegion: region, ignoreType: ignoreType) as PhoneNumber) != nil
    }
}

fileprivate extension ZPhoneNumberFormat {
    var asPhoneNumberFormat: PhoneNumberFormat {
        switch self {
        case .e164: .e164
        case .international: .international
        case .national: .national
        @unknown default:
            fatalError("We need to handle new cases of ZPhoneNumberFormat")
        }
    }
}

fileprivate extension PhoneNumber {
    var asZPhoneNumber: ZPhoneNumber {
        ZPhoneNumber(
            numberString: numberString,
            countryCode: countryCode,
            leadingZero: leadingZero,
            nationalNumber: nationalNumber,
            numberExtension: numberExtension,
            type: type.asZPhoneNumberType,
            regionID: regionID
        )
    }
}

fileprivate extension PhoneNumberType {
    var asZPhoneNumberType: ZPhoneNumberType {
        guard let zPhoneNumberType = ZPhoneNumberType(rawValue: rawValue) else {
            fatalError("We need to handle new cases of PhoneNumberType")
        }
        return zPhoneNumberType
    }
}
