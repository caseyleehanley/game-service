enum OmittableOptional<T>: Codable & Equatable where T: Codable & Equatable {
    case some(T)
    case none
    case omitted
    
    init<Key>(_ key: Key, using decoder: Decoder) throws where Key: CodingKey {
        let container = try decoder.container(keyedBy: Key.self)
        if container.contains(key) {
            if let value = try? container.decodeIfPresent(T.self, forKey: key) {
                self = .some(value)
            } else {
                self = .none
            }
        } else {
            self = .omitted
        }
    }
    
    var value: T? {
        switch self {
        case .some(let value):
            return value
        case .none, .omitted:
            return nil
        }
    }
}
