@testable import App
import XCTVapor
import Testing

@Suite("GameCharacterPivot: Controller")
final class GameCharacterPivotControllerTests: AppTest {
    typealias Resource = GameCharacterPivot
    
    let path = "api/v1/game_character_pivot"
    
    @Test("GET /api/v1/game_character_pivot")
    func index() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        for _ in 0..<5 { try await factory.make() }
        
        let response = try await perform(.GET, path)
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 5)
    }
    
    @Test("GET /api/v1/game_character_pivot/:id")
    func find() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await perform(.GET, "\(path)/\(id)")
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.id == id)
    }
    
    @Test("POST /api/v1/game_character_pivot")
    func create() async throws {
        let factory = Resource.CreateFactory(db: app.db)
        let content = try await factory.make().encode()
        
        let response = try await perform(.POST, path, content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.id != nil)
    }
    
    @Test("PUT /api/v1/game_character_pivot/:id")
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
    
    @Test("DELETE /api/v1/game_character_pivot/:id")
    func delete() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await app.sendRequest(.DELETE, "\(path)/\(id)")
        #expect(response.status == .noContent)
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
    
    @Test("?include_character=true")
    func includeCharacter() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make()
        
        let response = try await perform(.GET, "\(path)?include_character=true")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.first?.character != nil)
    }
    
    @Test("?include_character=true&characterName=Mario")
    func filterByCharacterName() async throws {
        let characterFactory = Character.ModelFactory(db: app.db)
        let mario = try await characterFactory.make(name: "Mario")
        let luigi = try await characterFactory.make(name: "Luigi")
        
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(characterID: try mario.requireID())
        try await factory.make(characterID: try mario.requireID())
        try await factory.make(characterID: try luigi.requireID())
        
        let response = try await perform(.GET, "\(path)?include_character=true&characterName=Mario")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 2)
    }
    
    @Test("?include_game=true&gameRating=null")
    func filterByCharacterRatingNil() async throws {
        let gameFactory = Game.ModelFactory(db: app.db)
        let withRating = try await gameFactory.make(rating: 10)
        let withoutRating = try await gameFactory.make()
        
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(gameID: try withRating.requireID())
        try await factory.make(gameID: try withoutRating.requireID())
        try await factory.make(gameID: try withoutRating.requireID())
        
        let response = try await perform(.GET, "\(path)?include_game=true&gameRating=null")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 2)
    }
}
