@testable import App
import XCTVapor
import Testing

@Suite("GameGameCharacterPivotPivot: DTOs")
final class GameCharacterPivotDTOTests: AppTest {
    @Test("Create -> toModel()")
    func toModel() async throws {
        let create = try await GameCharacterPivot.CreateFactory(db: app.db).make()
        let model = try create.toModel()
        #expect(model.$game.id != nil)
        #expect(model.$character.id != nil)
    }
    
    @Test("Update -> apply(to:)")
    func apply() async throws {
        let newID = UUID()
        
        let model = try await GameCharacterPivot.ModelFactory(db: app.db).make()
        let updates = try await GameCharacterPivot.UpdateFactory(db: app.db).make(gameID: newID)
        updates.apply(to: model)
        #expect(model.$game.id == newID)
    }
}
