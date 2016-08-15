import UIKit

class PGShowVC: PGTableViewController {
    let showVM: PGShowVM

    init(showVM: PGShowVM) {
        self.showVM = showVM

        super.init(viewModel: self.showVM, style: .grouped)

        self.viewModelViewAssociation = [PGShowVMTypeIds.cover.rawValue         : PGCoverShowCell.self,
                                         PGShowVMTypeIds.title.rawValue         : PGTextCell.self,
                                         PGShowVMTypeIds.date.rawValue          : PGTextCell.self,
                                         PGShowVMTypeIds.listen.rawValue        : PGTextCell.self,
                                         PGShowVMTypeIds.downloadShare.rawValue : PGTextCell.self,
        
        self.viewModelsBackgroundColors = [PGShowVMTypeIds.listen.rawValue          : UIColor.white,
                                           PGShowVMTypeIds.downloadShare.rawValue   : UIColor.white]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
