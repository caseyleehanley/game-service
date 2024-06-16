@testable import App
import struct Foundation.Date
import struct Foundation.UUID
import Fluent

extension Platform: TestableResource {
    typealias ModelFactory = PlatformModelFactory
    typealias CreateFactory = PlatformCreateFactory
    typealias UpdateFactory = PlatformUpdateFactory
}

struct PlatformModelFactory {
    let db: Database

    @discardableResult
    func make(
        name: String = "Switch",
        releaseDate: Date = Date.now,
        rating: Double? = nil,
        companyID: UUID? = nil
    ) async throws -> Platform.Model {
        var companyID = companyID
        if companyID == nil {
            companyID = try (try await CompanyModelFactory(db: db).make()).requireID()
        }
        let platform = Platform.Model(
            name: name,
            releaseDate: releaseDate,
            rating: rating,
            companyID: companyID!
        )
        try await platform.save(on: db)
        return platform
    }
}

struct PlatformCreateFactory {
    let db: Database

    @discardableResult
    func make(
        name: String = "Switch",
        releaseDate: Date = Date.now,
        rating: Double? = nil,
        companyID: UUID? = nil
    ) async throws -> Platform.Create {
        var companyID = companyID
        if companyID == nil {
            companyID = try (try await CompanyModelFactory(db: db).make()).requireID()
        }
        return Platform.Create(
            name: name,
            releaseDate: releaseDate.toString(),
            rating: rating,
            companyID: companyID!
        )
    }
}

struct PlatformUpdateFactory {
    let db: Database

    @discardableResult
    func make(
        name: String? = nil,
        releaseDate: Date? = nil,
        rating: OmittableOptional<Double> = .omitted,
        companyID: UUID? = nil
    ) async throws -> Platform.Update {
        return Platform.Update(
            name: name,
            releaseDate: releaseDate,
            rating: rating,
            companyID: companyID
        )
    }
}
