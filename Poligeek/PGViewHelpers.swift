import UIKit

extension UIView {

    func pg_usingAutoLayout() -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = true
        return self
    }

}

extension UITableView {

    func pg_register(class classToRegister: AnyClass) {
        self.register(classToRegister, forCellReuseIdentifier: NSStringFromClass(classToRegister))
    }

    func pg_register(classes classesToRegister: [AnyClass]) {
        for classToRegister in classesToRegister {
            self.pg_register(class: classToRegister)
        }
    }

}

extension UITableViewCell {

    static var pg_cellIdentifier: String {
        return NSStringFromClass(self)
    }

}

extension UIWebView {

    func pg_htmlStructurePrefix() -> String {
        let prefix = "<!DOCTYPE HTML><html lang=\"fr\"><head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no\"><style>\(self.pg_css())</style></head><body>"
        return prefix
    }

    func pg_htmlStructurePostfix() -> String {
        return "</body></html>"
    }

    func pg_css() -> String {
        return "*{font-family:'SF UI Text',sans-serif;} body{margin:0;padding:0;color:\(UIColor.darkText.pg_hexCode);} html{background-color:\(PGUI.backgroundColor.pg_hexCode);} h2{font-size:1em;} a{color:\(PGUI.tintColor.pg_hexCode);} hr{border:0;border-bottom:1px solid \(UIColor.lightGray.pg_hexCode);}}"
    }

    func pg_encapsulate(html: String) -> String {
        return pg_htmlStructurePrefix() + html + pg_htmlStructurePostfix()
    }
}

extension UIImageView {

    var pg_imageCacheDirectoryURL: URL? {
        return try? FileManager.default.url(for: .cachesDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
    }

    func pg_setImage(url: URL, placeholder: UIImage?) {
        self.image = placeholder

        guard let folderURL = self.pg_imageCacheDirectoryURL else { return }
        let filename = url.pg_sanitizedFilename
        let fileURL = folderURL.appendingPathComponent(filename)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let data = try? Data(contentsOf: fileURL) {
                let image = UIImage(data: data, scale: UIScreen.main.scale)
                self.image = image
                return
            }
        }

        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url) { data, reponse, error in
            guard let data = data, error == nil else {
                return
            }

            let image = UIImage(data: data, scale: UIScreen.main.scale)

            DispatchQueue.main.async {
                self.image = image
                try? data.write(to: fileURL)
            }
        }
        task.resume()
    }

}

extension URL {
    var pg_sanitizedFilename: String {
        guard let sanitizedString = self.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return "" }
        return sanitizedString
    }
}
