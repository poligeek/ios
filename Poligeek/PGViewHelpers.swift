import UIKit

extension UIView {

    func pg_usingAutoLayout() -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = true
        return self
    }

}

fileprivate var pg_separatorAssociationKey: UInt8 = 0
fileprivate var pg_topSeparatorAssociationKey: UInt8 = 0

extension UIView { // Separators
	private var pg_separator: UIView? {
		get {
			return objc_getAssociatedObject(self, &pg_separatorAssociationKey) as? UIView
		}
		set(newValue) {
			objc_setAssociatedObject(self, &pg_separatorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	private var pg_topSeparator: UIView? {
		get {
			return objc_getAssociatedObject(self, &pg_topSeparatorAssociationKey) as? UIView
		}
		set(newValue) {
			objc_setAssociatedObject(self, &pg_topSeparatorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	func pg_setSeparator(color: UIColor?, insets: UIEdgeInsets) {
		var separator = self.pg_separator
		
		if let color = color {
			var rect = CGRect(x: 0, y: self.bounds.size.height - PGUI.separatorHeight, width: self.bounds.size.width, height: PGUI.separatorHeight)
			rect = UIEdgeInsetsInsetRect(rect, insets)
			
			if separator == nil {
				separator = UIView(frame: rect)
				guard let separator = separator else { return }
				
				separator.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
				separator.layer.borderWidth = separator.frame.size.height
				self.addSubview(separator)
				
				self.pg_separator = separator
			}
			
			
			separator?.layer.borderColor = color.cgColor
			separator?.frame = rect
		} else {
			separator?.removeFromSuperview()
			self.pg_separator = nil
		}
	}
	
	func pg_setTopSeparator(color: UIColor?, insets: UIEdgeInsets) {
		var separator = self.pg_topSeparator
		
		if let color = color {
			var rect = CGRect(x: 0, y: -PGUI.separatorHeight, width: self.bounds.size.width, height: PGUI.separatorHeight)
			rect = UIEdgeInsetsInsetRect(rect, insets)
			
			if separator == nil {
				separator = UIView(frame: rect)
				guard let separator = separator else { return }
				
				separator.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
				separator.layer.borderWidth = separator.frame.size.height
				self.addSubview(separator)
				
				self.pg_topSeparator = separator
			}
			
			separator?.layer.borderColor = color.cgColor
			separator?.frame = rect
		} else {
			separator?.removeFromSuperview()
			self.pg_topSeparator = nil
		}
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
