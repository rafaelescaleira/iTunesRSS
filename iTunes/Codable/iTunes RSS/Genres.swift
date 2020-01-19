import Foundation

struct Genres : Codable {
    
	let genreId : String?
	let name : String?
	let url : String?

	enum CodingKeys: String, CodingKey {

		case genreId = "genreId"
		case name = "name"
		case url = "url"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		genreId = try values.decodeIfPresent(String.self, forKey: .genreId)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}
}
