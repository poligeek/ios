import Foundation

struct PGBigUp
{
    let name: String
    let title: String
    let url: URL

    enum PGBigUpKeys: String
    {
        case name = "name"
        case title = "title"
        case url = "url"
    }

    init?(json: [String : AnyObject])
    {
        guard let name = json[PGBigUpKeys.name.rawValue] as? String else { return nil }
        guard let title = json[PGBigUpKeys.title.rawValue] as? String else { return nil }
        guard let link = json[PGBigUpKeys.url.rawValue] as? String else { return nil }
        guard let url = URL(string: link) else { return nil }

        self.name = name
        self.title = title
        self.url = url
    }
}
