import struct Foundation.UUID
import Fluent

typealias GameCharacterPivotModel = GameCharacterPivotModelV1

final class GameCharacterPivotModelV1: ResourceModel, @unchecked Sendable {
    static let schema = "game_character_pivot"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "game_id")
    var game: Game.Model
    
    @Parent(key: "character_id")
    var character: Character.Model
    
    init() {}

    init(
        id: UUID? = nil,
        gameID: UUID,
        characterID: UUID
    ) {
        self.id = id
        self.$game.id = gameID
        self.$character.id = characterID
    }
    
    func toRead() throws -> GameCharacterPivot.Read {
        return .init(
            id: try self.requireID(),
            gameID: self.$game.id,
            characterID: self.$character.id,
            game: try self.$game.value?.toRead(),
            character: try self.$character.value?.toRead()
        )
    }
}
