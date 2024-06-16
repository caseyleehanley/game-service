struct Game: CRUDResource {
    static let path = "games"
    typealias Model = GameModel
    typealias Read = GameReadDTO
    typealias Create = GameCreateDTO
    typealias Update = GameUpdateDTO
}
