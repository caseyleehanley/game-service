@testable import App
import Fluent

extension Character: TestableResource {
    typealias ModelFactory = CharacterModelFactory
    typealias CreateFactory = CharacterCreateFactory
    typealias UpdateFactory = CharacterUpdateFactory
}

struct CharacterModelFactory {
    let db: Database

    @discardableResult
    func make(
        name: String = "Mario",
        age: Int = 43,
        favoriteColor: String? = nil
    ) async throws -> Character.Model {
        let character = Character.Model(
            name: name,
            age: age,
            favoriteColor: favoriteColor
        )
        try await character.save(on: db)
        return character
    }
}

struct CharacterCreateFactory {
    let db: Database

    @discardableResult
    func make(
        name: String = "Mario",
        age: Int = 43,
        favoriteColor: String? = nil
    ) async throws -> Character.Create {
        return Character.Create(
            name: name,
            age: age,
            favoriteColor: favoriteColor
        )
    }
}

struct CharacterUpdateFactory {
    let db: Database

    @discardableResult
    func make(
        name: String? = nil,
        age: Int? = nil,
        favoriteColor: OmittableOptional<String> = .omitted
    ) async throws -> Character.Update {
        return Character.Update(
            name: name,
            age: age,
            favoriteColor: favoriteColor
        )
    }
}
