import Vapor
import Fluent

extension GameCharacterPivotModel: Queryable {
    enum FilterKeys: String, CaseIterable, QueryKey, TypedQueryKey {
        case characterName
        case gameRating
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .characterName, .gameRating: .custom
            }
        }
        
        var type: QueryKeyType {
            switch self {
            case .characterName: .string
            case .gameRating: .double
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
        case game
        case character
    }
}

extension QueryBuilder where Model == GameCharacterPivotModel {
    @discardableResult
    func includeRelations(keyedBy keys: [QueryRelationKey<Model>]) -> Self {
        for key in keys {
            switch key.key {
            case .game: self.join(parent: \.$game).with(\.$game)
            case .character: self.join(parent: \.$character).with(\.$character)
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
                case .characterName: self.filter(Character.Model.self, \.$name, "name", by: key)
                case .gameRating: self.filter(Game.Model.self, \.$rating, "rating", by: key)
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
