import Foundation

struct Results : Codable {
    
	let artistName : String?
	let id : String?
	let releaseDate : String?
	let name : String?
	let kind : String?
	let copyright : String?
	let artistId : String?
	let contentAdvisoryRating : String?
	let artistUrl : String?
	let artworkUrl100 : String?
	let genres : [Genres]?
	let url : String?

	enum CodingKeys: String, CodingKey {

		case artistName = "artistName"
		case id = "id"
		case releaseDate = "releaseDate"
		case name = "name"
		case kind = "kind"
		case copyright = "copyright"
		case artistId = "artistId"
		case contentAdvisoryRating = "contentAdvisoryRating"
		case artistUrl = "artistUrl"
		case artworkUrl100 = "artworkUrl100"
		case genres = "genres"
		case url = "url"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		artistName = try values.decodeIfPresent(String.self, forKey: .artistName)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
		artistId = try values.decodeIfPresent(String.self, forKey: .artistId)
		contentAdvisoryRating = try values.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
		artistUrl = try values.decodeIfPresent(String.self, forKey: .artistUrl)
		artworkUrl100 = try values.decodeIfPresent(String.self, forKey: .artworkUrl100)
		genres = try values.decodeIfPresent([Genres].self, forKey: .genres)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}
}
