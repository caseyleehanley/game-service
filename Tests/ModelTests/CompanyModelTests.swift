@testable import App
import XCTVapor
import Testing

@Suite("Company: Models")
final class CompanyModelTests: AppTest {
    @Test("toRead()")
    func toRead() async throws {
        let model = try await Company.ModelFactory(db: app.db).make()
        let read = try model.toRead()
        #expect(model.name == read.name)
    }
}
