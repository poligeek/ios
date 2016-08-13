import UIKit

class PGShowVC: PGTableViewController {
    let showVM: PGShowVM

    init(showVM: PGShowVM) {
        self.showVM = showVM

        super.init(viewModel: self.showVM, style: .grouped)

        self.viewModelViewAssociation = [PGShowVMTypeIds.cover.rawValue : PGCoverShowCell.self,
                                         PGShowVMTypeIds.title.rawValue : PGTextCell.self,
                                         PGShowVMTypeIds.date.rawValue  : PGTextCell.self,]
        self.viewModelsBackgroundColors = [ : ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
