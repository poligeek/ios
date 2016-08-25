import UIKit
import SafariServices
import CoreGraphics

class PGShowVC: PGTableViewController {
    
    let showVM: PGShowVM
    let closeButton = UIButton()
    let statusBarBackground = UIView()
    var statusBarHidden: Bool = false

    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    init(showVM: PGShowVM) {
        self.showVM = showVM

        super.init(viewModel: self.showVM, style: .grouped)

        self.showVM.displayWebPage = { (url) in
            let safariVC = SFSafariViewController(url: url)
            self.navigationController?.pushViewController(safariVC, animated: true)
        }

        self.viewModelViewAssociation = [PGShowVMTypeIds.cover.rawValue         : PGCoverShowCell.self,
                                         PGShowVMTypeIds.title.rawValue         : PGTextCell.self,
                                         PGShowVMTypeIds.date.rawValue          : PGTextCell.self,
                                         PGShowVMTypeIds.listen.rawValue        : PGTextCell.self,
                                         PGShowVMTypeIds.downloadShare.rawValue : PGTextCell.self,
                                         PGShowVMTypeIds.notes.rawValue         : PGHTMLCell.self,]
        
        self.viewModelsBackgroundColors = [PGShowVMTypeIds.listen.rawValue          : UIColor.white,
                                           PGShowVMTypeIds.downloadShare.rawValue   : UIColor.white]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.statusBarBackground.backgroundColor = PGUI.tintColor
        self.tableView.addSubview(self.statusBarBackground)
        self.statusBarBackground.frame = CGRect(x: 0, y: 0, width: 1000, height: 20)


        self.closeButton.backgroundColor = UIColor.green
        self.closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        self.tableView.addSubview(self.closeButton)
        self.closeButton.frame = CGRect(x: PGUI.margin, y: PGUI.margin + 20, width: 44, height: 44)
    }

    func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.statusBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.statusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidLayoutSubviews() {
        print(min(0, self.tableView.contentOffset.y))

        let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))

        if self.tableView.contentOffset.y < 0 {
            firstCell?.frame.origin.y = self.tableView.contentOffset.y + 20
        } else {
            firstCell?.frame.origin.y = 20
        }
        let transform = CGAffineTransform(translationX: 0, y: min(0, self.tableView.contentOffset.y))

//        firstCell?.transform = transform
        self.statusBarBackground.transform = transform
        self.closeButton.transform = transform

        self.tableView.bringSubview(toFront: self.statusBarBackground)
        self.tableView.bringSubview(toFront: self.closeButton)
    }

}
