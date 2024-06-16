import struct Foundation.Date
import struct Foundation.UUID
import Fluent

typealias PlatformModel = PlatformModelV1

final class PlatformModelV1: ResourceModel, @unchecked Sendable {
    static let schema = "platforms"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "release_date")
    var releaseDate: Date
    
    @OptionalField(key: "rating")
    var rating: Double?
    
    @Parent(key: "company_id")
    var company: Company.Model
    
    @Siblings(through: PlatformGamePivot.Model.self, from: \.$platform, to: \.$game)
    var games: [Game.Model]
    
    init() {}

    init(
        id: UUID? = nil,
        name: String,
        releaseDate: Date,
        rating: Double?,
        companyID: UUID
    ) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.rating = rating
        self.$company.id = companyID
    }
    
    func toRead() throws -> Platform.Read {
        return .init(
            id: try self.requireID(),
            name: self.name,
            releaseDate: self.releaseDate,
            rating: self.rating,
            companyID: self.$company.id,
            company: try self.$company.value?.toRead(),
            games: try self.$games.value?.map({ try $0.toRead() })
        )
    }
}
