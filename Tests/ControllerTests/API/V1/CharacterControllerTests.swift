@testable import App
import XCTVapor
import Testing

@Suite("Character: Controller")
final class CharacterControllerTests: AppTest {
    typealias Resource = Character
    
    let path = "api/v1/characters"
    
    @Test("GET /api/v1/characters")
    func index() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        for _ in 0..<5 { try await factory.make() }
        
        let response = try await perform(.GET, path)
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 5)
    }
    
    @Test("GET /api/v1/characters/:id")
    func find() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await perform(.GET, "\(path)/\(id)")
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.id == id)
    }
    
    @Test("POST /api/v1/characters")
    func create() async throws {
        let name = "Mario"
        
        let factory = Resource.CreateFactory(db: app.db)
        let content = try await factory.make(name: name).encode()
        
        let response = try await perform(.POST, path, content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.name == name)
    }
    
    @Test("PUT /api/v1/characters/:id")
    func update() async throws {
        let oldName = "Maria"
        let newName = "Mario"
        
        let modelFactory = Resource.ModelFactory(db: app.db)
        let id = try (try await modelFactory.make(name: oldName)).requireID()
        
        let updateFactory = Resource.UpdateFactory(db: app.db)
        let content = try await updateFactory.make(name: newName).encode()
        
        let response = try await perform(.PUT, "\(path)/\(id)", content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.name == newName)
    }
    
    @Test("DELETE /api/v1/characters/:id")
    func delete() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await app.sendRequest(.DELETE, "\(path)/\(id)")
        #expect(response.status == .noContent)
    }
    
    @Test("?include_games=true")
    func includeGames() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let character = try await factory.make()
        
        let gameFactory = Game.ModelFactory(db: app.db)
        let game = try await gameFactory.make()
        
        let gameCharacterFactory = GameCharacterPivot.ModelFactory(db: app.db)
        try await gameCharacterFactory.make(
            gameID: try game.requireID(),
            characterID: try character.requireID()
        )
        
        let response = try await perform(.GET, "\(path)?include_games=true")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.first?.games?.count == 1)
    }
    
    @Test("?name=Mario")
    func filterByName() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(name: "Mario")
        try await factory.make(name: "Luigi")
        
        let response = try await perform(.GET, "\(path)?name=Mario")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 1)
        #expect(reads.first?.name == "Mario")
    }
    
    @Test("?favoriteColor=null")
    func filterByNil() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(name: "Mario", favoriteColor: "Red")
        try await factory.make(name: "Boo")
        
        let response = try await perform(.GET, "\(path)?favoriteColor=null")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 1)
        #expect(reads.first?.name == "Boo")
    }
    
    @Test("?favoriteColor_notEq=null")
    func filterByNonNil() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(name: "Mario", favoriteColor: "Red")
        try await factory.make(name: "Boo")
        
        let response = try await perform(.GET, "\(path)?favoriteColor_notEq=null")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 1)
        #expect(reads.first?.name == "Mario")
    }
    
    @Test("?name=Mario,Luigi")
    func filterByMultipleValues() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(name: "Mario")
        try await factory.make(name: "Luigi")
        try await factory.make(name: "Peach")
        try await factory.make(name: "Bowser")
        
        let response = try await perform(.GET, "\(path)?name=Mario,Luigi")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 2)
    }
    
    @Test("?name_contains=a,e")
    func filterByMultipleValuesContains() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(name: "Mario")
        try await factory.make(name: "Luigi")
        try await factory.make(name: "Peach")
        try await factory.make(name: "Bowser")
        
        let response = try await perform(.GET, "\(path)?name_contains=a,e")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 3)
    }
    
    @Test("?name_notEq=Luigi,Bowser")
    func filterByMultipleValuesNotEquals() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(name: "Mario")
        try await factory.make(name: "Luigi")
        try await factory.make(name: "Peach")
        try await factory.make(name: "Bowser")
        
        let response = try await perform(.GET, "\(path)?name_notEq=Luigi,Bowser")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 2)
    }
    
    @Test("PUT favoriteColor=nil")
    func updateNilValue() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make(favoriteColor: "Red")).requireID()
        
        let updateFactory = Resource.UpdateFactory(db: app.db)
        let content = try await updateFactory.make(favoriteColor: .none).encode()
        
        let response = try await perform(.PUT, "\(path)/\(id)", content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.favoriteColor == nil)
    }
}
