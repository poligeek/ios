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
        titleVM.textInset = UIEdgeInsets(top: 0, left: PGUI.cellInset.left, bottom: 0, right: PGUI.cellInset.right)

        let dateVM = PGTextVM(show.releaseDate.pg_mediumDate())
        dateVM.vmType = PGShowVMTypeIds.date.rawValue
        dateVM.font = UIFont.preferredFont(forTextStyle: .footnote)
        dateVM.textAlignment = .center
        dateVM.textColor = UIColor.lightGray
        dateVM.textInset = UIEdgeInsets(top: 0, left: PGUI.cellInset.left, bottom: 0, right: PGUI.cellInset.right)

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

        var sectionViewModels = [PGTableViewSectionVM(viewModels: [coverVM, titleVM, dateVM]),
                                 PGTableViewSectionVM(viewModels: [listenVM, downloadVM]),
                                 PGTableViewSectionVM(viewModels: [notesVM]),]

        let sourcesVMs: [PGViewModel]? = show.sources?.map {
            let vm = PGTextVM($0.title)
            vm.vmType = PGShowVMTypeIds.source.rawValue
            vm.accessory = .disclosureIndicator

            let sourceURL = $0.url
            let components = URLComponents(url: sourceURL, resolvingAgainstBaseURL: false)
            vm.detailText = components?.host

            vm.isSelectable = true
            vm.onSelect = {
                self.displayWebPage?(sourceURL)
            }

            return vm
        }
        if let sourcesVMs = sourcesVMs {
            sectionViewModels.append(PGTableViewSectionVM(viewModels: sourcesVMs))
        }
        
        let bigUpVMs: [PGViewModel]? = show.bigUps?.map {
            let vm = PGTextVM($0.name)
            vm.vmType = PGShowVMTypeIds.bigUp.rawValue
            vm.textColor = UIColor.gray
            
            vm.detailText = $0.title
            vm.detailFont = UIFont.preferredFont(forTextStyle: .body)
            vm.detailTextColor = UIColor.darkText
            
            if let url = $0.url {
                vm.isSelectable = true
                vm.onSelect = {
                    self.displayWebPage?(url)
                }
                vm.accessory = .disclosureIndicator
            }
            
            return vm
        }
        if let bigUpVMs = bigUpVMs {
            sectionViewModels.append(PGTableViewSectionVM(viewModels: bigUpVMs))
        }

        self.sectionViewModels = sectionViewModels
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
    var textInset = PGUI.cellInset

    var detailText: String?
    var detailFont: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    var detailTextAlignment = NSTextAlignment.left
    var detailTextColor = UIColor.gray

    var accessory: UITableViewCellAccessoryType = .none

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
    case source
    case bigUp
    case coverSource
}
