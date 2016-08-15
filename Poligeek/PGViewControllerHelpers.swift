import UIKit

extension UIViewController {

    func pg_embedInNavC() -> PGNavigationController {
        return PGNavigationController(rootViewController: self)
    }
    
}

class PGNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
