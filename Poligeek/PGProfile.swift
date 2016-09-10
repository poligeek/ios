import Foundation

class PGProfile
{
    
    var shows: [PGShow] = []

    func reloadShows(completion: (([PGShow]?, Error?) -> Void)?) throws
    {
        guard let url = URL(string: "http://localhost:4000/api") else { throw PGProfileError.InvalidURL }

        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url) { data, reponse, error in
            guard let data = data, error == nil else {
                completion?(nil, error)
                return
            }

            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDic = json as? [String: AnyObject] else {
                completion?(nil, PGProfileError.BadFormat)
                return
            }

            guard let jsonShows = jsonDic["shows"] as? [[String : AnyObject]] else {
                completion?(nil, PGProfileError.BadFormat)
                return
            }

            var shows: [PGShow] = []
            for jsonShow in jsonShows {
                if let show = PGShow(json: jsonShow) {
                    shows.append(show)
                }
            }

            self.shows = shows

            NotificationCenter.default.post(name: Notification.Name(PGShowsReloadedNotification), object: nil)
            completion?(self.shows, nil)
        }

        task.resume()
    }

}

enum PGProfileError: Error {

    case InvalidURL
    case BadFormat

}

let PGShowsReloadedNotification = "ShowsReloadedNotification"
