@testable import App
import XCTVapor
import Testing

@Suite("Company: DTOs")
final class CompanyDTOTests: AppTest {
    @Test("Create -> toModel()")
    func toModel() async throws {
        let create = try await Company.CreateFactory(db: app.db).make()
        let model = try create.toModel()
        #expect(model.name == create.name)
    }
    
    @Test("Update -> apply(to:)")
    func apply() async throws {
        let oldName = "Maria"
        let newName = "Mario"
        
        let model = try await Company.ModelFactory(db: app.db).make(name: oldName)
        let updates = try await Company.UpdateFactory(db: app.db).make(name: newName)
        updates.apply(to: model)
        #expect(model.name == newName)
    }
}
