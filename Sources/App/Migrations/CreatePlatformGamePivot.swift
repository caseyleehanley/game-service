import Fluent

struct CreatePlatformGamePivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("platform_game_pivot")
            .id()
            .field("platform_id", .uuid, .required, .references("platforms", "id", onDelete: .cascade))
            .field("game_id", .uuid, .required, .references("games", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("platform_game_pivot").delete()
    }
}
