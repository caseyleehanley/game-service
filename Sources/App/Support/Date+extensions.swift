import struct Foundation.Date
import class Foundation.DateFormatter
import struct Foundation.TimeZone

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let string = dateFormatter.string(from: self)
        return string
    }
}
