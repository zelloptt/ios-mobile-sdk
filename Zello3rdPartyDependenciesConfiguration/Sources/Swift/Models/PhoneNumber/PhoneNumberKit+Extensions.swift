import PhoneNumberKit
import Utility

extension PhoneNumberKit: Utility.ZelloPhoneNumberKit {
    public func format(_ phoneNumber: ZPhoneNumber, toType formatType: ZPhoneNumberFormat, withPrefix prefix: Bool) -> String {
        let regionID = phoneNumber.regionID ?? PhoneNumberKit.defaultRegionCode()
        guard let parsedPhoneNumber = try? parse(phoneNumber.numberString, withRegion: regionID) else {
            fatalError("This should never happen as this logic is mainly to convert Utility.PhoneNumber into PhoneNumberKit.PhoneNumber")
        }
        return format(parsedPhoneNumber, toType: formatType.asPhoneNumberFormat, withPrefix: prefix)
    }

    public func parse(_ numberString: String, withRegion region: String, ignoreType: Bool) throws -> ZPhoneNumber {
        try parse(numberString, withRegion: region, ignoreType: ignoreType).asZPhoneNumber
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
