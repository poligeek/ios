import UIKit
import SafariServices
import CoreGraphics

class PGShowVC: PGTableViewController {
    
    let showVM: PGShowVM
    let closeButton = UIButton()
    let topShadow = UIView()


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
        return 0.0000001
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.closeButton.setImage(#imageLiteral(resourceName: "close-arrow"), for: .normal)
        self.closeButton.setImage(#imageLiteral(resourceName: "close-arrow-selected"), for: .highlighted)
        self.closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        self.tableView.addSubview(self.closeButton)
        self.closeButton.frame = CGRect(x: UIScreen.main.bounds.width - PGUI.margin - 44, y: 20, width: 44, height: 44)

        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        layer.colors = [PGUI.tintColor.cgColor, PGUI.tintColor.withAlphaComponent(0).cgColor]
        self.topShadow.layer.addSublayer(layer)
        self.tableView.addSubview(self.topShadow)
        self.topShadow.frame = layer.frame
    }

    func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        firstCell?.frame.origin.y = min(0, self.tableView.contentOffset.y)

        let transform = CGAffineTransform(translationX: 0, y: min(0, self.tableView.contentOffset.y))
        self.topShadow.transform = transform
        self.closeButton.transform = transform

        self.tableView.bringSubview(toFront: self.topShadow)
        self.tableView.bringSubview(toFront: self.closeButton)
    }

}
