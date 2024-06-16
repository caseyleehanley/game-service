@testable import App
import XCTVapor
import Testing

@Suite("Character: Models")
final class CharacterModelTests: AppTest {
    @Test("toRead()")
    func toRead() async throws {
        let model = try await Character.ModelFactory(db: app.db).make()
        let read = try model.toRead()
        #expect(model.name == read.name)
    }
}
