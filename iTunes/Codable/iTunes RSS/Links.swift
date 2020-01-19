import Foundation

struct Links : Codable {
    
	let selfLink : String?

	enum CodingKeys: String, CodingKey {

		case selfLink = "self"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		selfLink = try values.decodeIfPresent(String.self, forKey: .selfLink)
	}
}
