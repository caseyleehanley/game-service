import struct Foundation.UUID

struct PlatformGamePivotReadDTO: ReadDTO {
    let id: UUID
    let platformID: UUID
    let gameID: UUID
    let platform: Platform.Read?
    let game: Game.Read?
}

struct PlatformGamePivotCreateDTO: CreateDTO {
    let platformID: UUID
    let gameID: UUID
    
    func toModel() throws -> PlatformGamePivot.Model {
        return .init(
            platformID: self.platformID,
            gameID: self.gameID
        )
    }
}

struct PlatformGamePivotUpdateDTO: UpdateDTO {
    let platformID: UUID?
    let gameID: UUID?
    
    func apply(to model: PlatformGamePivot.Model) {
        if let platformID {
            model.$platform.id = platformID
        }
        if let gameID {
            model.$game.id = gameID
        }
    }
}
