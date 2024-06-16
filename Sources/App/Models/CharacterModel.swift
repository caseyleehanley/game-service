import struct Foundation.UUID
import Fluent

typealias CharacterModel = CharacterModelV1

final class CharacterModelV1: ResourceModel, @unchecked Sendable {
    static let schema = "characters"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "age")
    var age: Int
    
    @OptionalField(key: "favorite_color")
    var favoriteColor: String?
    
    @Siblings(through: GameCharacterPivot.Model.self, from: \.$character, to: \.$game)
    var games: [Game.Model]
    
    init() {}

    init(
        id: UUID? = nil,
        name: String,
        age: Int,
        favoriteColor: String?
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.favoriteColor = favoriteColor
    }
    
    func toRead() throws -> Character.Read {
        return .init(
            id: try self.requireID(),
            name: self.name,
            age: self.age,
            favoriteColor: self.favoriteColor,
            games: try self.$games.value?.map({ try $0.toRead() })
        )
    }
}
