@testable import App
import struct Foundation.Date
import struct Foundation.UUID
import Fluent

extension GameCharacterPivot: TestableResource {
    typealias ModelFactory = GameCharacterPivotModelFactory
    typealias CreateFactory = GameCharacterPivotCreateFactory
    typealias UpdateFactory = GameCharacterPivotUpdateFactory
}

struct GameCharacterPivotModelFactory {
    let db: Database

    @discardableResult
    func make(
        gameID: UUID? = nil,
        characterID: UUID? = nil
    ) async throws -> GameCharacterPivot.Model {
        var gameID = gameID
        if gameID == nil {
            gameID = try (try await GameModelFactory(db: db).make()).requireID()
        }
        var characterID = characterID
        if characterID == nil {
            characterID = try (try await CharacterModelFactory(db: db).make()).requireID()
        }
        let gameCharacterPivot = GameCharacterPivot.Model(
            gameID: gameID!,
            characterID: characterID!
        )
        try await gameCharacterPivot.save(on: db)
        return gameCharacterPivot
    }
}

struct GameCharacterPivotCreateFactory {
    let db: Database

    @discardableResult
    func make(
        gameID: UUID? = nil,
        characterID: UUID? = nil
    ) async throws -> GameCharacterPivot.Create {
        var gameID = gameID
        if gameID == nil {
            gameID = try (try await GameModelFactory(db: db).make()).requireID()
        }
        var characterID = characterID
        if characterID == nil {
            characterID = try (try await CharacterModelFactory(db: db).make()).requireID()
        }
        return GameCharacterPivot.Create(
            gameID: gameID!,
            characterID: characterID!
        )
    }
}

struct GameCharacterPivotUpdateFactory {
    let db: Database

    @discardableResult
    func make(
        gameID: UUID? = nil,
        characterID: UUID? = nil
    ) async throws -> GameCharacterPivot.Update {
        return GameCharacterPivot.Update(
            gameID: gameID,
            characterID: characterID
        )
    }
}
