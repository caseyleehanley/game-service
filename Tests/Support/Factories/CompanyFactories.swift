@testable import App
import Fluent

extension Company: TestableResource {
    typealias ModelFactory = CompanyModelFactory
    typealias CreateFactory = CompanyCreateFactory
    typealias UpdateFactory = CompanyUpdateFactory
}

struct CompanyModelFactory {
    let db: Database

    @discardableResult
    func make(
        name: String = "Nintendo",
        employeeCount: Int = 7724
    ) async throws -> Company.Model {
        let company = Company.Model(
            name: name,
            employeeCount: employeeCount
        )
        try await company.save(on: db)
        return company
    }
}

struct CompanyCreateFactory {
    let db: Database

    @discardableResult
    func make(
        name: String = "Nintendo",
        employeeCount: Int = 7724
    ) async throws -> Company.Create {
        return Company.Create(
            name: name,
            employeeCount: employeeCount
        )
    }
}

struct CompanyUpdateFactory {
    let db: Database

    @discardableResult
    func make(
        name: String? = nil,
        employeeCount: Int? = nil
    ) async throws -> Company.Update {
        return Company.Update(
            name: name,
            employeeCount: employeeCount
        )
    }
}
