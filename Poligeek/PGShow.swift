import Foundation

struct PGShow
{

    let identifier: String
    let title: String
    let number: String
    let releaseDate: Date
    let recordDate: Date
    let shortDescription: String
    let duration: TimeInterval
    let keywords: [String]
    let text: String

    var largeCoverURL: URL {
        return URL(string: "http://storage.poligeek.fr/assets/cover\(self.number).png")!
    }
    var smallCoverURL: URL {
        return URL(string: "http://storage.poligeek.fr/assets/cover\(self.number)-small.png")!
    }
    var fileURL: URL {
        return URL(string: "http://storage.poligeek.fr/shows/show\(self.number).mp3")!
    }

    init?(json: [String : AnyObject])
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss Z"

        guard let identifier = json[PGShowKeys.identifier.rawValue] as? String else { return nil }
        guard let title = json[PGShowKeys.title.rawValue] as? String else { return nil }
        guard let number = json[PGShowKeys.number.rawValue] as? String else { return nil }
        guard let releaseDateString = json[PGShowKeys.releaseDate.rawValue] as? String else { return nil }
        guard let releaseDate = dateFormatter.date(from: releaseDateString) else { return nil }
        guard let recordDateString = json[PGShowKeys.recordDate.rawValue] as? String else { return nil }
        guard let recordDate = dateFormatter.date(from: recordDateString) else { return nil }
        guard let shortDescription = json[PGShowKeys.shortDescription.rawValue] as? String else { return nil }
        guard let durationString = json[PGShowKeys.duration.rawValue] as? String else { return nil }
        guard let keywords = json[PGShowKeys.keywords.rawValue] as? String else { return nil }
        guard let text = json[PGShowKeys.text.rawValue] as? String else { return nil }

        let durationValues = durationString.components(separatedBy: ":")
        var duration: TimeInterval = 0.0
        for i in 0..<durationValues.count {
            let factor = pow(Double(60.0), Double(durationValues.count - 1 - i))
            guard let value = Double(durationValues[durationValues.count - 1 - i]) else { return nil }
            duration += value * factor
        }

        self.identifier = identifier
        self.title = title
        self.number = number
        self.releaseDate = releaseDate
        self.recordDate = recordDate
        self.shortDescription = shortDescription
        self.duration = duration
        self.keywords = keywords.components(separatedBy: ", ")
        self.text = text
    }

}

enum PGShowKeys: String
{

    case identifier = "identifier"
    case title = "title"
    case number = "number"
    case releaseDate = "date"
    case recordDate = "record_date"
    case shortDescription = "theme_debat"
    case duration = "duration"
    case keywords = "keywords"
    case text = "text"
    
}
