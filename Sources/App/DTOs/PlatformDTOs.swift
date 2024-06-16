import struct Foundation.Date
import struct Foundation.UUID

struct PlatformReadDTO: ReadDTO {
    let id: UUID
    let name: String
    let releaseDate: Date
    let rating: Double?
    let companyID: UUID
    let company: Company.Read?
    let games: [Game.Read]?
}

struct PlatformCreateDTO: CreateDTO {
    let name: String
    let releaseDate: String
    let rating: Double?
    let companyID: UUID
    
    func toModel() throws -> Platform.Model {
        return .init(
            name: self.name,
            releaseDate: try self.releaseDate.toDate(),
            rating: self.rating,
            companyID: self.companyID
        )
    }
}

struct PlatformUpdateDTO: UpdateDTO {
    let name: String?
    let releaseDate: Date?
    let rating: OmittableOptional<Double>
    let companyID: UUID?
    
    func apply(to model: Platform.Model) {
        if let name {
            model.name = name
        }
        if let releaseDate {
            model.releaseDate = releaseDate
        }
        if rating != .omitted {
            model.rating = rating.value
        }
        if let companyID {
            model.$company.id = companyID
        }
    }
}

extension PlatformUpdateDTO {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            releaseDate = try releaseDateString.toDate()
        } else {
            releaseDate = nil
        }
        rating = try .init(CodingKeys.rating, using: decoder)
        companyID = try container.decodeIfPresent(UUID.self, forKey: .companyID)
    }
}
