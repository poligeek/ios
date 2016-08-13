import Foundation

extension Date {

    func pg_mediumDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }

}
