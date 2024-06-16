@testable import App
import XCTVapor
import Testing

@Suite("Platform: Models")
final class PlatformModelTests: AppTest {
    @Test("toRead()")
    func toRead() async throws {
        let model = try await Platform.ModelFactory(db: app.db).make()
        let read = try model.toRead()
        #expect(model.name == read.name)
    }
}
