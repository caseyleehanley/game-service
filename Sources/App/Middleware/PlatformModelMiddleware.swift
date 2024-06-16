import Fluent

struct PlatformModelMiddleware: AsyncModelMiddleware {
    func create(
        model: PlatformModel,
        on db: Database,
        next: AnyAsyncModelResponder
    ) async throws {
        // Add code before create...
        try await next.create(model, on: db)
    }
    
    func update(
        model: PlatformModel,
        on db: any Database,
        next: any AnyAsyncModelResponder
    ) async throws {
        // Add code before update...
        try await next.update(model, on: db)
    }
    
    func delete(
        model: PlatformModel,
        force: Bool,
        on db: any Database,
        next: any AnyAsyncModelResponder
    ) async throws {
        // Add code before delete...
        try await next.delete(model, force: force, on: db)
    }
}
