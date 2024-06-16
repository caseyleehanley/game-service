import struct Foundation.Date
import struct Foundation.UUID
import Fluent

typealias GameModel = GameModelV1

final class GameModelV1: ResourceModel, @unchecked Sendable {
    static let schema = "games"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "release_date")
    var releaseDate: Date
    
    @OptionalField(key: "rating")
    var rating: Double?
    
    @Siblings(through: PlatformGamePivot.Model.self, from: \.$game, to: \.$platform)
    var platforms: [Platform.Model]
    
    @Siblings(through: GameCharacterPivot.Model.self, from: \.$game, to: \.$character)
    var characters: [Character.Model]
    
    init() {}

    init(
        id: UUID? = nil,
        name: String,
        releaseDate: Date,
        rating: Double?
    ) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.rating = rating
    }
    
    func toRead() throws -> Game.Read {
        return .init(
            id: try self.requireID(),
            name: self.name,
            releaseDate: self.releaseDate,
            rating: self.rating,
            platforms: try self.$platforms.value?.map({ try $0.toRead() }),
            characters: try self.$characters.value?.map({ try $0.toRead() })
        )
    }
}
