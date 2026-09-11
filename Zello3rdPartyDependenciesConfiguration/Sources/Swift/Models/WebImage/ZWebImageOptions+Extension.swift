import Utility
import SDWebImage

extension ZWebImageOptions {
    var asSDWebImageOptions: SDWebImageOptions {
        SDWebImageOptions(rawValue: rawValue)
    }
}
