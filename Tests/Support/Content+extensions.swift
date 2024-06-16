import Vapor

extension Content {
    func encode(using encoder: JSONEncoder = JSONEncoder()) throws -> ByteBuffer? {
        encoder.dateEncodingStrategy = .iso8601
        let body = try encoder.encode(self)
        return ByteBuffer(data: body)
    }
}
