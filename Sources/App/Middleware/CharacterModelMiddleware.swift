import Fluent

struct CharacterModelMiddleware: AsyncModelMiddleware {
    func create(
        model: CharacterModel,
        on db: Database,
        next: AnyAsyncModelResponder
    ) async throws {
        // Add code before create...
        try await next.create(model, on: db)
    }
    
    func update(
        model: CharacterModel,
        on db: any Database,
        next: any AnyAsyncModelResponder
    ) async throws {
        // Add code before update...
        try await next.update(model, on: db)
    }
    
    func delete(
        model: CharacterModel,
        force: Bool,
        on db: any Database,
        next: any AnyAsyncModelResponder
    ) async throws {
        // Add code before delete...
        try await next.delete(model, force: force, on: db)
    }
}
