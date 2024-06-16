import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) async throws {
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "game-service",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    // .e.g, app.databases.middleware.use(EntityModelMiddleware(), on: .psql)
    app.databases.middleware.use(CompanyModelMiddleware(), on: .psql)
    app.databases.middleware.use(PlatformModelMiddleware(), on: .psql)
    app.databases.middleware.use(GameModelMiddleware(), on: .psql)
    app.databases.middleware.use(CharacterModelMiddleware(), on: .psql)
    app.databases.middleware.use(PlatformGamePivotModelMiddleware(), on: .psql)
    app.databases.middleware.use(GameCharacterPivotModelMiddleware(), on: .psql)
    
    // .e.g, app.migrations.add(CreateEntity())
    app.migrations.add(CreateCompany())
    app.migrations.add(CreatePlatform())
    app.migrations.add(CreateGame())
    app.migrations.add(CreateCharacter())
    app.migrations.add(CreatePlatformGamePivot())
    app.migrations.add(CreateGameCharacterPivot())
    
    try routes(app)
}
