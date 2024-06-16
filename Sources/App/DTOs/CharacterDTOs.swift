import struct Foundation.UUID

struct CharacterReadDTO: ReadDTO {
    let id: UUID
    let name: String
    let age: Int
    let favoriteColor: String?
    let games: [Game.Read]?
}

struct CharacterCreateDTO: CreateDTO {
    let name: String
    let age: Int
    let favoriteColor: String?
    
    func toModel() throws -> Character.Model {
        return .init(
            name: self.name,
            age: self.age,
            favoriteColor: self.favoriteColor
        )
    }
}

struct CharacterUpdateDTO: UpdateDTO {
    let name: String?
    let age: Int?
    let favoriteColor: OmittableOptional<String>
    
    func apply(to model: Character.Model) {
        if let name {
            model.name = name
        }
        if let age {
            model.age = age
        }
        if favoriteColor != .omitted {
            model.favoriteColor = favoriteColor.value
        }
    }
}

extension CharacterUpdateDTO {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        age = try container.decodeIfPresent(Int.self, forKey: .age)
        favoriteColor = try .init(CodingKeys.favoriteColor, using: decoder)
    }
}
