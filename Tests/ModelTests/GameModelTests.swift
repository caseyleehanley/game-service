@testable import App
import XCTVapor
import Testing

@Suite("Game: Models")
final class GameModelTests: AppTest {
    @Test("toRead()")
    func toRead() async throws {
        let model = try await Game.ModelFactory(db: app.db).make()
        let read = try model.toRead()
        #expect(model.name == read.name)
    }
}
