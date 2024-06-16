import Vapor
import Fluent

extension PlatformModel: Queryable {
    enum FilterKeys: String, CaseIterable, QueryKey, TypedQueryKey {
        case name
        case releaseDate = "release_date"
        case rating
        case companyName
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .name, .releaseDate, .rating: .standard
            case .companyName: .custom
            }
        }
        
        var type: QueryKeyType {
            switch self {
            case .name, .companyName: .string
            case .releaseDate: .date
            case .rating: .double
            }
        }
    }
    
    enum SortKeys: String, CaseIterable, QueryKey {
        case name
        case releaseDate = "release_date"
        case rating
        case companyName
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .name, .releaseDate, .rating: .standard
            case .companyName: .custom
            }
        }
    }
    
    enum RelationKeys: CaseIterable {
        case company
        case games
    }
}

extension QueryBuilder where Model == PlatformModel {
    @discardableResult
    func includeRelations(keyedBy keys: [QueryRelationKey<Model>]) -> Self {
        for key in keys {
            switch key.key {
            case .company: self.join(parent: \.$company).with(\.$company)
            case .games: self.with(\.$games)
            }
        }
        return self
    }
    
    @discardableResult
    func filter(by keys: [QueryFilterKey<Model>]) throws -> Self {
        for key in keys {
            switch key.implementation {
            case .standard: self.filter(by: key)
            case .custom:
                switch key.key {
                case .companyName: self.filter(Company.Model.self, \.$name, "name", by: key)
                default: throw Abort(.notImplemented)
                }
            }
        }
        return self
    }
    
    @discardableResult
    func sort(by keys: [QuerySortKey<Model>]) throws -> Self {
        for key in keys {
            switch key.implementation {
            case .standard: self.sort(by: key)
            case .custom:
                switch key.key {
                case .companyName: self.sort(Company.Model.self, \.$name, key.direction)
                default: throw Abort(.notImplemented)
                }
            }
        }
        return self
    }
}
