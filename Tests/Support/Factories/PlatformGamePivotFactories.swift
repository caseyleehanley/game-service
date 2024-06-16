@testable import App
import struct Foundation.Date
import struct Foundation.UUID
import Fluent

extension PlatformGamePivot: TestableResource {
    typealias ModelFactory = PlatformGamePivotModelFactory
    typealias CreateFactory = PlatformGamePivotCreateFactory
    typealias UpdateFactory = PlatformGamePivotUpdateFactory
}

struct PlatformGamePivotModelFactory {
    let db: Database

    @discardableResult
    func make(
        platformID: UUID? = nil,
        gameID: UUID? = nil
    ) async throws -> PlatformGamePivot.Model {
        var platformID = platformID
        if platformID == nil {
            platformID = try (try await PlatformModelFactory(db: db).make()).requireID()
        }
        var gameID = gameID
        if gameID == nil {
            gameID = try (try await GameModelFactory(db: db).make()).requireID()
        }
        let platformGamePivot = PlatformGamePivot.Model(
            platformID: platformID!,
            gameID: gameID!
        )
        try await platformGamePivot.save(on: db)
        return platformGamePivot
    }
}

struct PlatformGamePivotCreateFactory {
    let db: Database

    @discardableResult
    func make(
        platformID: UUID? = nil,
        gameID: UUID? = nil
    ) async throws -> PlatformGamePivot.Create {
        var platformID = platformID
        if platformID == nil {
            platformID = try (try await PlatformModelFactory(db: db).make()).requireID()
        }
        var gameID = gameID
        if gameID == nil {
            gameID = try (try await GameModelFactory(db: db).make()).requireID()
        }
        return PlatformGamePivot.Create(
            platformID: platformID!,
            gameID: gameID!
        )
    }
}

struct PlatformGamePivotUpdateFactory {
    let db: Database

    @discardableResult
    func make(
        platformID: UUID? = nil,
        gameID: UUID? = nil
    ) async throws -> PlatformGamePivot.Update {
        return PlatformGamePivot.Update(
            platformID: platformID,
            gameID: gameID
        )
    }
}
