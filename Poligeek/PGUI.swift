import UIKit

struct PGUI {
    
    static func configure(application: UIApplication) {
        for window in UIApplication.shared.windows {
            window.tintColor = PGUI.tintColor
            window.layer.cornerRadius = PGUI.cornerRadius
            window.layer.masksToBounds = true
        }
        
        UINavigationBar.appearance().barTintColor = PGUI.tintColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isOpaque = true
    }
    
    static let tintColor = UIColor(red: 0.365, green: 0.267, blue: 0.435, alpha: 1)
    static let backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
    static let yellowColor = UIColor(red: 1, green: 0.831, blue: 0, alpha: 1)
    
    static let cornerRadius: CGFloat = 5
    static let margin: CGFloat = 8
    
    static let cellMargin: CGFloat = 13
    static let cellInset = UIEdgeInsets(top: PGUI.margin,
                                        left: PGUI.cellMargin,
                                        bottom: PGUI.margin,
                                        right: PGUI.cellMargin)
    static let separatorInset = UIEdgeInsets(top: 0,
                                             left: PGUI.cellMargin,
                                             bottom: 0,
                                             right: 0)
    static let cellHeight: CGFloat = 44
    static let separatorHeight: CGFloat = PGUI.onePixel
    static let tableViewSectionHeaderHeight: CGFloat = 10
    static let tableViewSectionFooterHeight: CGFloat = 10
    
    static let onePixel: CGFloat = 1.0 / UIScreen.main.scale
    
}
