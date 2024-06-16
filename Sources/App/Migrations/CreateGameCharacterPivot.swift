import Fluent

struct CreateGameCharacterPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("game_character_pivot")
            .id()
            .field("game_id", .uuid, .required, .references("games", "id", onDelete: .cascade))
            .field("character_id", .uuid, .required, .references("characters", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("game_character_pivot").delete()
    }
}
