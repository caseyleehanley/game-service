import Fluent

struct CreatePlatform: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("platforms")
            .id()
            .field("name", .string, .required)
            .field("release_date", .date, .required)
            .field("rating", .double)
            .field("company_id", .uuid, .required, .references("companies", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("platforms").delete()
    }
}
