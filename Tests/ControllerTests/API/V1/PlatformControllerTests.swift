@testable import App
import XCTVapor
import Testing

@Suite("Platform: Controller")
final class PlatformControllerTests: AppTest {
    typealias Resource = Platform
    
    let path = "api/v1/platforms"
    
    @Test("GET /api/v1/platforms")
    func index() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        for _ in 0..<5 { try await factory.make() }
        
        let response = try await perform(.GET, path)
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 5)
    }
    
    @Test("GET /api/v1/platforms/:id")
    func find() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await perform(.GET, "\(path)/\(id)")
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.id == id)
    }
    
    @Test("POST /api/v1/platforms")
    func create() async throws {
        let name = "Swift"
        
        let factory = Resource.CreateFactory(db: app.db)
        let content = try await factory.make(name: name).encode()
        
        let response = try await perform(.POST, path, content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.name == name)
    }
    
    @Test("PUT /api/v1/platforms/:id")
    func update() async throws {
        let oldName = "Swoft"
        let newName = "Swift"
        
        let modelFactory = Resource.ModelFactory(db: app.db)
        let id = try (try await modelFactory.make(name: oldName)).requireID()
        
        let updateFactory = Resource.UpdateFactory(db: app.db)
        let content = try await updateFactory.make(name: newName).encode()
        
        let response = try await perform(.PUT, "\(path)/\(id)", content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.name == newName)
    }
    
    @Test("DELETE /api/v1/platforms/:id")
    func delete() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await app.sendRequest(.DELETE, "\(path)/\(id)")
        #expect(response.status == .noContent)
    }
    
    @Test("?include_company=true")
    func includeCompany() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make()
        
        let response = try await perform(.GET, "\(path)?include_company=true")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.first?.company != nil)
    }
    
    @Test("?include_games=true")
    func includeGames() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let platform = try await factory.make()
        
        let gameFactory = Game.ModelFactory(db: app.db)
        let game = try await gameFactory.make()
        
        let platformGameFactory = PlatformGamePivot.ModelFactory(db: app.db)
        try await platformGameFactory.make(
            platformID: try platform.requireID(),
            gameID: try game.requireID()
        )
        
        let response = try await perform(.GET, "\(path)?include_games=true")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.first?.games?.count == 1)
    }
    
    @Test("?name=Switch")
    func filterByName() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(name: "Wii")
        try await factory.make(name: "Switch")
        try await factory.make(name: "GameCube")
        
        let response = try await perform(.GET, "\(path)?name=Switch")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 1)
        #expect(reads.first?.name == "Switch")
    }
    
    @Test("?rating=10")
    func filterByRating() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(rating: 10)
        try await factory.make(rating: 5)
        try await factory.make(rating: 0)
        
        let response = try await perform(.GET, "\(path)?rating=10")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 1)
        #expect(reads.first?.rating == 10)
    }
    
    @Test("?include_company=true&companyName=Nintendo")
    func filterByCompanyName() async throws {
        let companyFactory = Company.ModelFactory(db: app.db)
        let nintendo = try await companyFactory.make(name: "Nintendo")
        let sony = try await companyFactory.make(name: "Sony")
        let microsoft = try await companyFactory.make(name: "Microsoft")
        
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(companyID: try nintendo.requireID())
        try await factory.make(companyID: try sony.requireID())
        try await factory.make(companyID: try microsoft.requireID())
        
        let response = try await perform(.GET, "\(path)?include_company=true&companyName=Nintendo")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 1)
    }
    
    @Test("?include_company=true&sortBy=companyName")
    func sortByCompanyName() async throws {
        let companyFactory = Company.ModelFactory(db: app.db)
        let nintendo = try await companyFactory.make(name: "Nintendo")
        let sony = try await companyFactory.make(name: "Sony")
        let microsoft = try await companyFactory.make(name: "Microsoft")
        
        let factory = Resource.ModelFactory(db: app.db)
        let nintendoPlatform = try await factory.make(companyID: try nintendo.requireID())
        let sonyPlatform = try await factory.make(companyID: try sony.requireID())
        let microsoftPlatform = try await factory.make(companyID: try microsoft.requireID())
        
        let response = try await perform(.GET, "\(path)?include_company=true&sortBy=companyName")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 3)
        #expect(reads[0].id == microsoftPlatform.id)
        #expect(reads[1].id == nintendoPlatform.id)
        #expect(reads[2].id == sonyPlatform.id)
    }
    
    @Test("?include_company=true&sortBy=companyName&sortDirection=descending")
    func sortByCompanyNameReverse() async throws {
        let companyFactory = Company.ModelFactory(db: app.db)
        let nintendo = try await companyFactory.make(name: "Nintendo")
        let sony = try await companyFactory.make(name: "Sony")
        let microsoft = try await companyFactory.make(name: "Microsoft")
        
        let factory = Resource.ModelFactory(db: app.db)
        let nintendoPlatform = try await factory.make(companyID: try nintendo.requireID())
        let sonyPlatform = try await factory.make(companyID: try sony.requireID())
        let microsoftPlatform = try await factory.make(companyID: try microsoft.requireID())
        
        let response = try await perform(.GET, "\(path)?include_company=true&sortBy=companyName&sortDirection=descending")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 3)
        #expect(reads[0].id == sonyPlatform.id)
        #expect(reads[1].id == nintendoPlatform.id)
        #expect(reads[2].id == microsoftPlatform.id)
    }
    
    @Test("?include_company=true&companyName=Nintendo,Microsoft&sortBy=companyName")
    func filterAndSortByCompanyName() async throws {
        let companyFactory = Company.ModelFactory(db: app.db)
        let nintendo = try await companyFactory.make(name: "Nintendo")
        let sony = try await companyFactory.make(name: "Sony")
        let microsoft = try await companyFactory.make(name: "Microsoft")
        
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(companyID: try nintendo.requireID())
        try await factory.make(companyID: try nintendo.requireID())
        try await factory.make(companyID: try sony.requireID())
        try await factory.make(companyID: try sony.requireID())
        try await factory.make(companyID: try microsoft.requireID())
        
        let response = try await perform(.GET, "\(path)?include_company=true&companyName=Nintendo,Microsoft&sortBy=companyName")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 3)
        #expect(reads[0].company?.id == microsoft.id)
        #expect(reads[1].company?.id == nintendo.id)
        #expect(reads[2].company?.id == nintendo.id)
    }
}
