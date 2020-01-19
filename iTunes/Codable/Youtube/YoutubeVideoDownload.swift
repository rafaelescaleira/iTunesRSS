import Foundation
import UIKit

public struct YoutubeVideoDownload: Codable {
    
    let height : String?
    let itag : String?
    let mimeType : String?
    let quality : String?
    let qualityLabel : String?
    let type : String?
    let url : String?
    let width : String?
    
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case itag = "itag"
        case mimeType = "mimeType"
        case quality = "quality"
        case qualityLabel = "qualityLabel"
        case type = "type"
        case url = "url"
        case width = "width"
    }
}
