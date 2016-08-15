import UIKit

class PGShowVM: PGTableViewVM {
    let show: PGShow

    init(show: PGShow) {
        self.show = show

        super.init()

        let coverVM = PGShowCoverVM(show: self.show)
        coverVM.vmType = PGShowVMTypeIds.cover.rawValue

        let titleVM = PGTextVM(show.titleWithNumber)
        titleVM.vmType = PGShowVMTypeIds.title.rawValue
        titleVM.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleTitle1)
        titleVM.textAlignment = .center

        let dateVM = PGTextVM(show.releaseDate.pg_mediumDate())
        dateVM.vmType = PGShowVMTypeIds.date.rawValue
        dateVM.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleFootnote)
        dateVM.textAlignment = .center
        dateVM.textColor = UIColor.lightGray

        self.sectionViewModels = [PGTableViewSectionVM(viewModels: [coverVM, titleVM, dateVM]),
                                  PGTableViewSectionVM(viewModels: [])]
    }
}

class PGShowCoverVM: PGViewModel {
    var coverPath: String

    init(show: PGShow) {
        self.coverPath = "cover"
        super.init()
    }
}

class PGTextVM: PGViewModel {
    var text: String
    var font: UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyleBody)
    var textAlignment = NSTextAlignment.left
    var textColor = UIColor.darkText

    init(_ text: String) {
        self.text = text
        super.init()
    }

    override func isSelectable() -> Bool {
        return false
    }

    override func select() {
        
    }
}

enum PGShowVMTypeIds: String {
    case cover
    case title
    case date
}
