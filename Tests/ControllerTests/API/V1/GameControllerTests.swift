@testable import App
import XCTVapor
import Testing

@Suite("Game: Controller")
final class GameControllerTests: AppTest {
    typealias Resource = Game
    
    let path = "api/v1/games"
    
    @Test("GET /api/v1/games")
    func index() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        for _ in 0..<5 { try await factory.make() }
        
        let response = try await perform(.GET, path)
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 5)
    }
    
    @Test("GET /api/v1/games/:id")
    func find() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await perform(.GET, "\(path)/\(id)")
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.id == id)
    }
    
    @Test("POST /api/v1/games")
    func create() async throws {
        let name = "MarioKart"
        
        let factory = Resource.CreateFactory(db: app.db)
        let content = try await factory.make(name: name).encode()
        
        let response = try await perform(.POST, path, content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.name == name)
    }
    
    @Test("PUT /api/v1/games/:id")
    func update() async throws {
        let oldName = "MarioKert"
        let newName = "MarioKart"
        
        let modelFactory = Resource.ModelFactory(db: app.db)
        let id = try (try await modelFactory.make(name: oldName)).requireID()
        
        let updateFactory = Resource.UpdateFactory(db: app.db)
        let content = try await updateFactory.make(name: newName).encode()
        
        let response = try await perform(.PUT, "\(path)/\(id)", content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.name == newName)
    }
    
    @Test("DELETE /api/v1/games/:id")
    func delete() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await app.sendRequest(.DELETE, "\(path)/\(id)")
        #expect(response.status == .noContent)
    }
    
    @Test("?include_platforms=true")
    func includePlatforms() async throws {
        let platformFactory = Platform.ModelFactory(db: app.db)
        let platform = try await platformFactory.make()
        
        let factory = Resource.ModelFactory(db: app.db)
        let game = try await factory.make()
        
        let platformGameFactory = PlatformGamePivot.ModelFactory(db: app.db)
        try await platformGameFactory.make(
            platformID: try platform.requireID(),
            gameID: try game.requireID()
        )
        
        let response = try await perform(.GET, "\(path)?include_platforms=true")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.first?.platforms?.count == 1)
    }
    
    @Test("?include_characters=true")
    func includeGames() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let game = try await factory.make()
        
        let characterFactory = Character.ModelFactory(db: app.db)
        let character = try await characterFactory.make()
        
        let gameCharacterFactory = GameCharacterPivot.ModelFactory(db: app.db)
        try await gameCharacterFactory.make(
            gameID: try game.requireID(),
            characterID: try character.requireID()
        )
        
        let response = try await perform(.GET, "\(path)?include_characters=true")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.first?.characters?.count == 1)
    }
    
    @Test("?name=MarioKart")
    func filterByName() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(name: "Mario Party")
        try await factory.make(name: "MarioKart")
        try await factory.make(name: "Paper Mario")
        
        let response = try await perform(.GET, "\(path)?name=MarioKart")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 1)
        #expect(reads.first?.name == "MarioKart")
    }
    
    @Test("?rating=null")
    func filterByNil() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(rating: 10)
        try await factory.make(rating: 9)
        try await factory.make()
        try await factory.make()
        
        let response = try await perform(.GET, "\(path)?rating=null")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 2)
    }
}
