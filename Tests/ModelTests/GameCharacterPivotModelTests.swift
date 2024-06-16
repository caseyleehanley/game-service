@testable import App
import XCTVapor
import Testing

@Suite("GameCharacterPivot: Models")
final class GameCharacterPivotModelTests: AppTest {
    @Test("toRead()")
    func toRead() async throws {
        let model = try await GameCharacterPivot.ModelFactory(db: app.db).make()
        let read = try model.toRead()
        #expect(model.$game.id == read.gameID)
        #expect(model.$character.id == read.characterID)
    }
}
