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

    let sources: [PGSource]?
    let bigUps: [PGBigUp]?

    let coverAuthor: String?
    let coverName: String?
    let coverURL: URL?

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

        case sources = "sources"
        case bigUps = "big_ups"

        case cover = "cover"
        case coverAuthor = "author"
        case coverName = "name"
        case coverURL = "url"
    }

    var largeCoverURL: URL {
        return URL(string: "http://storage.poligeek.fr/assets/cover\(self.number).jpg")!
    }
    var smallCoverURL: URL {
        return URL(string: "http://storage.poligeek.fr/assets/cover\(self.number)-small.jpg")!
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

        if let sources = json[PGShowKeys.sources.rawValue] as? [[String: AnyObject]] {
            self.sources = sources.flatMap { return PGSource(json: $0) }
        } else {
            self.sources = nil
        }

        if let bigUps = json[PGShowKeys.bigUps.rawValue] as? [[String: AnyObject]] {
            self.bigUps = bigUps.flatMap { return PGBigUp(json: $0) }
        } else {
            self.bigUps = nil
        }

        if let coverAuthor = json[PGShowKeys.cover.rawValue]?[PGShowKeys.coverAuthor.rawValue] as? String,
            let coverName = json[PGShowKeys.cover.rawValue]?[PGShowKeys.coverName.rawValue] as? String,
            let coverLink = json[PGShowKeys.cover.rawValue]?[PGShowKeys.coverURL.rawValue] as? String,
            let coverURL = URL(string: coverLink) {
            self.coverAuthor = coverAuthor
            self.coverName = coverName
            self.coverURL = coverURL
        } else {
            self.coverAuthor = nil
            self.coverName = nil
            self.coverURL = nil
        }
    }
}
