import Fluent

struct GameModelMiddleware: AsyncModelMiddleware {
    func create(
        model: GameModel,
        on db: Database,
        next: AnyAsyncModelResponder
    ) async throws {
        // Add code before create...
        try await next.create(model, on: db)
    }
    
    func update(
        model: GameModel,
        on db: any Database,
        next: any AnyAsyncModelResponder
    ) async throws {
        // Add code before update...
        try await next.update(model, on: db)
    }
    
    func delete(
        model: GameModel,
        force: Bool,
        on db: any Database,
        next: any AnyAsyncModelResponder
    ) async throws {
        // Add code before delete...
        try await next.delete(model, force: force, on: db)
    }
}
