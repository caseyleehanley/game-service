@testable import App
import struct Foundation.Date
import Fluent

extension Game: TestableResource {
    typealias ModelFactory = GameModelFactory
    typealias CreateFactory = GameCreateFactory
    typealias UpdateFactory = GameUpdateFactory
}

struct GameModelFactory {
    let db: Database

    @discardableResult
    func make(
        name: String = "MarioKart",
        releaseDate: Date = Date.now,
        rating: Double? = nil
    ) async throws -> Game.Model {
        let game = Game.Model(
            name: name,
            releaseDate: releaseDate,
            rating: rating
        )
        try await game.save(on: db)
        return game
    }
}

struct GameCreateFactory {
    let db: Database

    @discardableResult
    func make(
        name: String = "MarioKart",
        releaseDate: Date = Date.now,
        rating: Double? = nil
    ) async throws -> Game.Create {
        return Game.Create(
            name: name,
            releaseDate: releaseDate.toString(),
            rating: rating
        )
    }
}

struct GameUpdateFactory {
    let db: Database

    @discardableResult
    func make(
        name: String? = nil,
        releaseDate: Date? = nil,
        rating: OmittableOptional<Double> = .omitted
    ) async throws -> Game.Update {
        return Game.Update(
            name: name,
            releaseDate: releaseDate,
            rating: rating
        )
    }
}
