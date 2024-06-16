import Vapor
import Fluent

extension CharacterModel: Queryable {
    enum FilterKeys: String, CaseIterable, QueryKey, TypedQueryKey {
        case name
        case age
        case favoriteColor = "favorite_color"
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .name, .age, .favoriteColor: .standard
            }
        }
        
        var type: QueryKeyType {
            switch self {
            case .name, .favoriteColor: .string
            case .age: .int
            }
        }
    }
    
    enum SortKeys: String, CaseIterable, QueryKey {
        case name
        case age
        case favoriteColor
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .name, .age, .favoriteColor: .standard
            }
        }
    }
    
    enum RelationKeys: CaseIterable {
        case games
    }
}

extension QueryBuilder where Model == CharacterModel {
    @discardableResult
    func includeRelations(keyedBy keys: [QueryRelationKey<Model>]) -> Self {
        for key in keys {
            switch key.key {
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
