import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let profile = PGProfile()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let vc = PGRootVC(profile: self.profile)

        try? self.profile.reloadShows(completion: nil)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc.pg_embedInNavC()
        self.window?.makeKeyAndVisible()

        PGUI.configure(application: application)

        return true
    }
}

