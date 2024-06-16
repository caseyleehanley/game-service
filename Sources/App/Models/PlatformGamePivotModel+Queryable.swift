import Vapor
import Fluent

extension PlatformGamePivotModel: Queryable {
    enum FilterKeys: String, CaseIterable, QueryKey, TypedQueryKey {
        case none
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .none: .standard
            }
        }
        
        var type: QueryKeyType {
            switch self {
            case .none: .string
            }
        }
    }
    
    enum SortKeys: String, CaseIterable, QueryKey {
        case none
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .none: .standard
            }
        }
    }
    
    enum RelationKeys: CaseIterable {
        case platform
        case game
    }
}

extension QueryBuilder where Model == PlatformGamePivotModel {
    @discardableResult
    func includeRelations(keyedBy keys: [QueryRelationKey<Model>]) -> Self {
        for key in keys {
            switch key.key {
            case .platform: self.join(parent: \.$platform).with(\.$platform)
            case .game: self.join(parent: \.$game).with(\.$game)            
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
