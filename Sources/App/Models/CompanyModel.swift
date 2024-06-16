import struct Foundation.UUID
import Fluent

typealias CompanyModel = CompanyModelV1

final class CompanyModelV1: ResourceModel, @unchecked Sendable {
    static let schema = "companies"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "employee_count")
    var employeeCount: Int
    
    @Children(for: \.$company)
    var platforms: [Platform.Model]
    
    init() {}

    init(
        id: UUID? = nil,
        name: String,
        employeeCount: Int
    ) {
        self.id = id
        self.name = name
        self.employeeCount = employeeCount
    }
    
    func toRead() throws -> Company.Read {
        return .init(
            id: try self.requireID(),
            name: self.name,
            employeeCount: self.employeeCount,
            platforms: try self.$platforms.value?.map({ try $0.toRead() })
        )
    }
}
