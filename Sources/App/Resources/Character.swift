struct Character: CRUDResource {
    static let path = "characters"
    typealias Model = CharacterModel
    typealias Read = CharacterReadDTO
    typealias Create = CharacterCreateDTO
    typealias Update = CharacterUpdateDTO
}
