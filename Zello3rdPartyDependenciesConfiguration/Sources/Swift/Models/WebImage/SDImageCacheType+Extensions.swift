import Utility
import SDWebImage

extension SDImageCacheType {
    var asZImageCacheType: ZImageCacheType {
        switch self {
        case .none:
            .none
        case .disk:
            .disk
        case .memory:
            .memory
        case .all:
            .all
        @unknown default:
            fatalError("We need to handle all SDImageCacheType cases")
        }
    }
}
