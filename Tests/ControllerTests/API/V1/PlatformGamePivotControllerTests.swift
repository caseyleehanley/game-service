@testable import App
import XCTVapor
import Testing

@Suite("PlatformGamePivot: Controller")
final class PlatformGamePivotControllerTests: AppTest {
    typealias Resource = PlatformGamePivot
    
    let path = "api/v1/platform_game_pivot"
    
    @Test("GET /api/v1/platform_game_pivot")
    func index() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        for _ in 0..<5 { try await factory.make() }
        
        let response = try await perform(.GET, path)
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 5)
    }
    
    @Test("GET /api/v1/platform_game_pivot/:id")
    func find() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await perform(.GET, "\(path)/\(id)")
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.id == id)
    }
    
    @Test("POST /api/v1/platform_game_pivot")
    func create() async throws {
        let factory = Resource.CreateFactory(db: app.db)
        let content = try await factory.make().encode()
        
        let response = try await perform(.POST, path, content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.id != nil)
    }
    
    @Test("PUT /api/v1/platform_game_pivot/:id")
    func update() async throws {
        let modelFactory = Resource.ModelFactory(db: app.db)
        let id = try (try await modelFactory.make()).requireID()
        
        let gameFactory = GameModelFactory(db: app.db)
        let newGameID = try await gameFactory.make().requireID()
        
        let updateFactory = Resource.UpdateFactory(db: app.db)
        let content = try await updateFactory.make(gameID: newGameID).encode()
        
        let response = try await perform(.PUT, "\(path)/\(id)", content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.gameID == newGameID)
    }
    
    @Test("DELETE /api/v1/platform_game_pivot/:id")
    func delete() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await app.sendRequest(.DELETE, "\(path)/\(id)")
        #expect(response.status == .noContent)
    }
    
    @Test("?include_platform=true")
    func includeCharacter() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make()
        
        let response = try await perform(.GET, "\(path)?include_platform=true")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.first?.platform != nil)
    }
    
    @Test("?include_game=true")
    func includeGame() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make()
        
        let response = try await perform(.GET, "\(path)?include_game=true")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.first?.game != nil)
    }
}
