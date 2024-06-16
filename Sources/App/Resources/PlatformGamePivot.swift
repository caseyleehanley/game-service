struct PlatformGamePivot: CRUDResource {
    static let path = "platform_game_pivot"
    typealias Model = PlatformGamePivotModel
    typealias Read = PlatformGamePivotReadDTO
    typealias Create = PlatformGamePivotCreateDTO
    typealias Update = PlatformGamePivotUpdateDTO
}
