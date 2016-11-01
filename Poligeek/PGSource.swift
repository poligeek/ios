import Foundation

struct PGSource
{
    let title: String
    let url: URL

    enum PGSourceKeys: String
    {
        case title = "title"
        case url = "url"
    }

    init?(json: [String : AnyObject])
    {
        guard let title = json[PGSourceKeys.title.rawValue] as? String else { return nil }
        guard let link = json[PGSourceKeys.url.rawValue] as? String else { return nil }
        guard let url = URL(string: link) else { return nil }

        self.title = title
        self.url = url
    }
}
