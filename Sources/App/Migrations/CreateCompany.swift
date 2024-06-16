import Fluent

struct CreateCompany: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("companies")
            .id()
            .field("name", .string, .required)
            .field("employee_count", .int, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("companies").delete()
    }
}
