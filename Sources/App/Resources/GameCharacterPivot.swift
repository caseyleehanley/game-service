struct GameCharacterPivot: CRUDResource {
    static let path = "game_character_pivot"
    typealias Model = GameCharacterPivotModel
    typealias Read = GameCharacterPivotReadDTO
    typealias Create = GameCharacterPivotCreateDTO
    typealias Update = GameCharacterPivotUpdateDTO
}
