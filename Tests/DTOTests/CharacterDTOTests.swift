@testable import App
import XCTVapor
import Testing

@Suite("Character: DTOs")
final class CharacterDTOTests: AppTest {
    @Test("Create -> toModel()")
    func toModel() async throws {
        let create = try await Character.CreateFactory(db: app.db).make()
        let model = try create.toModel()
        #expect(model.name == create.name)
    }
    
    @Test("Update -> apply(to:)")
    func apply() async throws {
        let oldName = "Maria"
        let newName = "Mario"
        
        let model = try await Character.ModelFactory(db: app.db).make(name: oldName)
        let updates = try await Character.UpdateFactory(db: app.db).make(name: newName)
        updates.apply(to: model)
        #expect(model.name == newName)
    }
}
