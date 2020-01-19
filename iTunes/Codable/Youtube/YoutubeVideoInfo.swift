import UIKit

public struct YoutubeVideoInfoCodable: Codable {
    
    let authorName : String?
    let authorUrl : String?
    let height : Int?
    let html : String?
    let providerName : String?
    let providerUrl : String?
    let thumbnailHeight : Int?
    let thumbnailUrl : String?
    let thumbnailWidth : Int?
    let title : String?
    let type : String?
    let version : String?
    let width : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case authorName = "author_name"
        case authorUrl = "author_url"
        case height = "height"
        case html = "html"
        case providerName = "provider_name"
        case providerUrl = "provider_url"
        case thumbnailHeight = "thumbnail_height"
        case thumbnailUrl = "thumbnail_url"
        case thumbnailWidth = "thumbnail_width"
        case title = "title"
        case type = "type"
        case version = "version"
        case width = "width"
    }
}
