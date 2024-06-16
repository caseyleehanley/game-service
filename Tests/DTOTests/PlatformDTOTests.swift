@testable import App
import XCTVapor
import Testing

@Suite("Platform: DTOs")
final class PlatformDTOTests: AppTest {
    @Test("Create -> toModel()")
    func toModel() async throws {
        let create = try await Platform.CreateFactory(db: app.db).make()
        let model = try create.toModel()
        #expect(model.name == create.name)
    }
    
    @Test("Update -> apply(to:)")
    func apply() async throws {
        let oldName = "Woo"
        let newName = "Wii"
        
        let model = try await Platform.ModelFactory(db: app.db).make(name: oldName)
        let updates = try await Platform.UpdateFactory(db: app.db).make(name: newName)
        updates.apply(to: model)
        #expect(model.name == newName)
    }
}
