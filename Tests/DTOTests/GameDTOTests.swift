@testable import App
import XCTVapor
import Testing

@Suite("Game: DTOs")
final class GameDTOTests: AppTest {
    @Test("Create -> toModel()")
    func toModel() async throws {
        let create = try await Game.CreateFactory(db: app.db).make()
        let model = try create.toModel()
        #expect(model.name == create.name)
    }
    
    @Test("Update -> apply(to:)")
    func apply() async throws {
        let oldName = "MarioKert"
        let newName = "MarioKart"
        
        let model = try await Game.ModelFactory(db: app.db).make(name: oldName)
        let updates = try await Game.UpdateFactory(db: app.db).make(name: newName)
        updates.apply(to: model)
        #expect(model.name == newName)
    }
}
