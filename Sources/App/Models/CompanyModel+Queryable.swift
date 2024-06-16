import Vapor
import Fluent

extension CompanyModel: Queryable {
    enum FilterKeys: String, CaseIterable, QueryKey, TypedQueryKey {
        case name
        case employeeCount = "employee_count"
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .name, .employeeCount: .standard
            }
        }
        
        var type: QueryKeyType {
            switch self {
            case .name: .string
            case .employeeCount: .int
            }
        }
    }
    
    enum SortKeys: String, CaseIterable, QueryKey {
        case name
        case employeeCount = "employee_count"
        
        var implementation: QueryKeyImplementation {
            switch self {
            case .name, .employeeCount: .standard
            }
        }
    }
    
    enum RelationKeys: CaseIterable {
        case platforms
    }
}

extension QueryBuilder where Model == CompanyModel {
    @discardableResult
    func includeRelations(keyedBy keys: [QueryRelationKey<Model>]) -> Self {
        for key in keys {
            switch key.key {
            case .platforms: self.with(\.$platforms)
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
