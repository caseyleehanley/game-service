struct Platform: CRUDResource {
    static let path = "platforms"
    typealias Model = PlatformModel
    typealias Read = PlatformReadDTO
    typealias Create = PlatformCreateDTO
    typealias Update = PlatformUpdateDTO
}
