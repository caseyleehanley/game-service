import struct Foundation.UUID

struct CompanyReadDTO: ReadDTO {
    let id: UUID
    let name: String
    let employeeCount: Int
    let platforms: [Platform.Read]?
}

struct CompanyCreateDTO: CreateDTO {
    let name: String
    let employeeCount: Int
    
    func toModel() throws -> Company.Model {
        return .init(
            name: self.name,
            employeeCount: self.employeeCount
        )
    }
}

struct CompanyUpdateDTO: UpdateDTO {
    let name: String?
    let employeeCount: Int?
    
    func apply(to model: Company.Model) {
        if let name {
            model.name = name
        }
        if let employeeCount {
            model.employeeCount = employeeCount
        }
    }
}
