import struct Foundation.UUID
import Fluent

typealias PlatformGamePivotModel = PlatformGamePivotModelV1

final class PlatformGamePivotModelV1: ResourceModel, @unchecked Sendable {
    static let schema = "platform_game_pivot"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "platform_id")
    var platform: Platform.Model

    @Parent(key: "game_id")
    var game: Game.Model
    
    init() {}

    init(
        id: UUID? = nil,
        platformID: UUID,
        gameID: UUID
    ) {
        self.id = id
        self.$platform.id = platformID
        self.$game.id = gameID
    }
    
    func toRead() throws -> PlatformGamePivot.Read {
        return .init(
            id: try self.requireID(),
            platformID: self.$platform.id,
            gameID: self.$game.id,
            platform: try self.$platform.value?.toRead(),
            game: try self.$game.value?.toRead()
        )
    }
}
