import Vapor
import Fluent

extension GameModel: Queryable {
    enum FilterKeys: String, CaseIterable, QueryKey, TypedQueryKey {
        case name
        case releaseDate
        case rating
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .name, .releaseDate, .rating: .standard
            }
        }
        
        var type: QueryKeyType {
            switch self {
            case .name: .string
            case .releaseDate: .date
            case .rating: .double
            }
        }
    }
    
    enum SortKeys: String, CaseIterable, QueryKey {
        case name
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .name: .standard
            }
        }
    }
    
    enum RelationKeys: CaseIterable {
        case platforms
        case characters
    }
}

extension QueryBuilder where Model == GameModel {
    @discardableResult
    func includeRelations(keyedBy keys: [QueryRelationKey<Model>]) -> Self {
        for key in keys {
            switch key.key {
            case .platforms: self.with(\.$platforms)
            case .characters: self.with(\.$characters)
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
                // Add code to implement custom filters here...
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
                // Add code to implement custom sorts here...
                default: throw Abort(.notImplemented)
                }
            }
        }
        return self
    }
}
