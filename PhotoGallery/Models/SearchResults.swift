
import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplahPhoto]
}

struct UnsplahPhoto: Decodable {
    let width : Int
    let height: Int
    let urls: [URLKind.RawValue: String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
