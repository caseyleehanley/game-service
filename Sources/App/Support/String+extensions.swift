import struct Foundation.Date
import class Foundation.DateFormatter

extension String {
    func toDate() throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            throw DecodingError.unableToDecodeDate
        }
        return date
    }
}
