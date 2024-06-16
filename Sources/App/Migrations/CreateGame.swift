import Fluent

struct CreateGame: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("games")
            .id()
            .field("name", .string, .required)
            .field("release_date", .date, .required)
            .field("rating", .double)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("games").delete()
    }
}
