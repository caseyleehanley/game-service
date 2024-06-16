@testable import App
import XCTVapor
import Testing

@Suite("PlatformGamePivot: DTOs")
final class PlatformGamePivotDTOTests: AppTest {
    @Test("Create -> toModel()")
    func toModel() async throws {
        let create = try await PlatformGamePivot.CreateFactory(db: app.db).make()
        let model = try create.toModel()
        #expect(model.$platform.id != nil)
        #expect(model.$game.id != nil)
    }
    
    @Test("Update -> apply(to:)")
    func apply() async throws {
        let newID = UUID()
        
        let model = try await PlatformGamePivot.ModelFactory(db: app.db).make()
        let updates = try await PlatformGamePivot.UpdateFactory(db: app.db).make(gameID: newID)
        updates.apply(to: model)
        #expect(model.$game.id == newID)
    }
}
