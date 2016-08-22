import UIKit

class PGShowVM: PGTableViewVM {
    let show: PGShow
    var displayWebPage: ((URL) -> Void)?

    init(show: PGShow) {
        self.show = show

        super.init()

        let coverVM = PGShowCoverVM(show: self.show)
        coverVM.vmType = PGShowVMTypeIds.cover.rawValue

        let titleVM = PGTextVM(show.titleWithNumber)
        titleVM.vmType = PGShowVMTypeIds.title.rawValue
        titleVM.font = UIFont.preferredFont(forTextStyle: .title1)
        titleVM.textAlignment = .center

        let dateVM = PGTextVM(show.releaseDate.pg_mediumDate())
        dateVM.vmType = PGShowVMTypeIds.date.rawValue
        dateVM.font = UIFont.preferredFont(forTextStyle: .footnote)
        dateVM.textAlignment = .center
        dateVM.textColor = UIColor.lightGray

        let listenVM = PGTextVM(NSLocalizedString("ui.show.listen", comment: ""))
        listenVM.vmType = PGShowVMTypeIds.listen.rawValue
        listenVM.font = UIFont.preferredFont(forTextStyle: .body)
        listenVM.textAlignment = .center
        listenVM.textColor = PGUI.tintColor
        listenVM.isSelectable = true
        listenVM.onSelect = {
            print("[TODO] Listen \(show.titleWithNumber)")
        }

        let downloadVM = PGTextVM(NSLocalizedString("ui.show.download", comment: ""))
        downloadVM.vmType = PGShowVMTypeIds.downloadShare.rawValue
        downloadVM.font = UIFont.preferredFont(forTextStyle: .body)
        downloadVM.textAlignment = .center
        downloadVM.textColor = PGUI.tintColor
        downloadVM.isSelectable = true
        downloadVM.onSelect = {
            print("[TODO] Download  \(show.titleWithNumber)")
        }

        let notesVM = PGHTMLVM(show.text)
        notesVM.vmType = PGShowVMTypeIds.notes.rawValue
        notesVM.hypertextLinkSelected = { (url) in
            self.displayWebPage?(url)
        }

        self.sectionViewModels = [PGTableViewSectionVM(viewModels: [coverVM, titleVM, dateVM]),
                                  PGTableViewSectionVM(viewModels: [listenVM, downloadVM]),
                                  PGTableViewSectionVM(viewModels: [notesVM]),]
    }
}

class PGShowCoverVM: PGViewModel {
    var coverURL: URL

    init(show: PGShow) {
        self.coverURL = show.largeCoverURL
        super.init()
    }
}

class PGTextVM: PGViewModel {
    var text: String
    var font: UIFont = UIFont.preferredFont(forTextStyle: .body)
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

class PGHTMLVM: PGViewModel {
    var text: String
    var hypertextLinkSelected: ((URL) -> Void)?

    init(_ text: String) {
        self.text = text
        super.init()
    }
}

enum PGShowVMTypeIds: String {
    case cover
    case title
    case date
    case listen
    case downloadShare
    case notes
}
