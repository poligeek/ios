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
