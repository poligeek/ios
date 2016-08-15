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
