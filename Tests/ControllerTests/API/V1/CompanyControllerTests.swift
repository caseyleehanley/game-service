@testable import App
import XCTVapor
import Testing

@Suite("Company: Controller")
final class CompanyControllerTests: AppTest {
    typealias Resource = Company
    
    let path = "api/v1/companies"
    
    @Test("GET /api/v1/companies")
    func index() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        for _ in 0..<5 { try await factory.make() }
        
        let response = try await perform(.GET, path)
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 5)
    }
    
    @Test("GET /api/v1/companies/:id")
    func find() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await perform(.GET, "\(path)/\(id)")
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.id == id)
    }
    
    @Test("POST /api/v1/companies")
    func create() async throws {
        let name = "Nintendo"
        
        let factory = Resource.CreateFactory(db: app.db)
        let content = try await factory.make(name: name).encode()
        
        let response = try await perform(.POST, path, content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.name == name)
    }
    
    @Test("PUT /api/v1/companies/:id")
    func update() async throws {
        let oldName = "Nintondo"
        let newName = "Nintendo"
        
        let modelFactory = Resource.ModelFactory(db: app.db)
        let id = try (try await modelFactory.make(name: oldName)).requireID()
        
        let updateFactory = Resource.UpdateFactory(db: app.db)
        let content = try await updateFactory.make(name: newName).encode()
        
        let response = try await perform(.PUT, "\(path)/\(id)", content: content)
        #expect(response.status == .ok)
        
        let read = try response.content.decode(Resource.Read.self)
        #expect(read.name == newName)
    }
    
    @Test("DELETE /api/v1/companies/:id")
    func delete() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let id = try (try await factory.make()).requireID()
        
        let response = try await app.sendRequest(.DELETE, "\(path)/\(id)")
        #expect(response.status == .noContent)
    }
    
    @Test("?include_platforms=true")
    func includePlatforms() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        let company = try await factory.make()
        
        let platformFactory = Platform.ModelFactory(db: app.db)
        try await platformFactory.make(
            companyID: try company.requireID()
        )
        
        let response = try await perform(.GET, "\(path)?include_platforms=true")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.first?.platforms?.count == 1)
    }
    
    @Test("?name=Nintendo")
    func filterByName() async throws {
        let factory = Resource.ModelFactory(db: app.db)
        try await factory.make(name: "Nintendo")
        try await factory.make(name: "Sony")
        try await factory.make(name: "Microsoft")
        
        let response = try await perform(.GET, "\(path)?name=Nintendo")
        #expect(response.status == .ok)
        
        let reads = try response.content.decode([Resource.Read].self)
        #expect(reads.count == 1)
        #expect(reads.first?.name == "Nintendo")
    }
}
