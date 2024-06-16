import Fluent

struct CreateCharacter: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("characters")
            .id()
            .field("name", .string, .required)
            .field("age", .int, .required)
            .field("favorite_color", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("characters").delete()
    }
}
