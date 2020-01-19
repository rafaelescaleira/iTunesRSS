import Foundation

struct Author : Codable {
    
	let name : String?
	let uri : String?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case uri = "uri"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
	}
}
