import struct Foundation.UUID

struct GameCharacterPivotReadDTO: ReadDTO {
    let id: UUID
    let gameID: UUID
    let characterID: UUID
    let game: Game.Read?
    let character: Character.Read?
}

struct GameCharacterPivotCreateDTO: CreateDTO {
    let gameID: UUID
    let characterID: UUID
    
    func toModel() throws -> GameCharacterPivot.Model {
        return .init(
            gameID: self.gameID,
            characterID: self.characterID
        )
    }
}

struct GameCharacterPivotUpdateDTO: UpdateDTO {
    let gameID: UUID?
    let characterID: UUID?
    
    func apply(to model: GameCharacterPivot.Model) {
        if let gameID {
            model.$game.id = gameID
        }
        if let characterID {
            model.$character.id = characterID
        }
    }
}
