import struct Foundation.Date
import struct Foundation.UUID

struct GameReadDTO: ReadDTO {
    let id: UUID
    let name: String
    let releaseDate: Date
    let rating: Double?
    let platforms: [Platform.Read]?
    let characters: [Character.Read]?
}

struct GameCreateDTO: CreateDTO {
    let name: String
    let releaseDate: String
    let rating: Double?
    
    func toModel() throws -> Game.Model {
        return .init(
            name: self.name,
            releaseDate: try self.releaseDate.toDate(),
            rating: self.rating
        )
    }
}

struct GameUpdateDTO: UpdateDTO {
    let name: String?
    let releaseDate: Date?
    let rating: OmittableOptional<Double>
    
    func apply(to model: Game.Model) {
        if let name {
            model.name = name
        }
        if let releaseDate {
            model.releaseDate = releaseDate
        }
        if rating != .omitted {
            model.rating = rating.value
        }
    }
}

extension GameUpdateDTO {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            releaseDate = try releaseDateString.toDate()
        } else {
            releaseDate = nil
        }
        rating = try .init(CodingKeys.rating, using: decoder)
    }
}
