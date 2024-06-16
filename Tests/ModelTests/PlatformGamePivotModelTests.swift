@testable import App
import XCTVapor
import Testing

@Suite("PlatformGamePivot: Models")
final class PlatformGamePivotModelTests: AppTest {
    @Test("toRead()")
    func toRead() async throws {
        let model = try await PlatformGamePivot.ModelFactory(db: app.db).make()
        let read = try model.toRead()
        #expect(model.$platform.id == read.platformID)
        #expect(model.$game.id == read.gameID)
    }
}
