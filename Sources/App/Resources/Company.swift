struct Company: CRUDResource {
    static let path = "companies"
    typealias Model = CompanyModel
    typealias Read = CompanyReadDTO
    typealias Create = CompanyCreateDTO
    typealias Update = CompanyUpdateDTO
}
