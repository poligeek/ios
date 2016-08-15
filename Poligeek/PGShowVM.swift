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

        let listenVM = PGTextVM(NSLocalizedString("ui.show.listen", comment: ""))
        listenVM.vmType = PGShowVMTypeIds.listen.rawValue
        listenVM.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleBody)
        listenVM.textAlignment = .center
        listenVM.textColor = PGUI.tintColor
        listenVM.isSelectable = true
        listenVM.onSelect = {
            print("[TODO] Listen \(show.titleWithNumber)")
        }

        let downloadVM = PGTextVM(NSLocalizedString("ui.show.download", comment: ""))
        downloadVM.vmType = PGShowVMTypeIds.downloadShare.rawValue
        downloadVM.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleBody)
        downloadVM.textAlignment = .center
        downloadVM.textColor = PGUI.tintColor
        downloadVM.isSelectable = true
        downloadVM.onSelect = {
            print("[TODO] Download  \(show.titleWithNumber)")
        }
        self.sectionViewModels = [PGTableViewSectionVM(viewModels: [coverVM, titleVM, dateVM]),
                                  PGTableViewSectionVM(viewModels: [])]
                                  PGTableViewSectionVM(viewModels: [listenVM, downloadVM]),
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

    var onSelect: (() -> Void)?

    init(_ text: String) {
        self.text = text
        super.init()
    }

    override func select() {
        self.onSelect?()
    }
}

    }
}

enum PGShowVMTypeIds: String {
    case cover
    case title
    case date
    case listen
    case downloadShare
}
