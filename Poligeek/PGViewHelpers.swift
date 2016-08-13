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
