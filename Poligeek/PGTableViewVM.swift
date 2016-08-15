import Foundation

class PGTableViewVM {
    var title: String?
    var sectionViewModels: [PGTableViewSectionVMProtocol] = []

    var headerViewModel: PGViewModel?
    var footerViewModel: PGViewModel?

    var numberOfSections: Int {
        return self.sectionViewModels.count
    }

    func numberOfRows(section: Int) -> Int {
        return self.sectionViewModels[section].numberOfRows
    }

    func viewModel(indexPath: IndexPath) -> PGViewModel {
        return self.sectionViewModels[indexPath.section].viewModel(index: indexPath.row)
    }

    func headerViewModel(forSection section: Int) -> PGViewModel? {
        return self.sectionViewModels[section].headerViewModel
    }

    func footerViewModel(forSection section: Int) -> PGViewModel? {
        return self.sectionViewModels[section].footerViewModel
    }

    func canSelectViewModel(indexPath: IndexPath) -> Bool {
        let vm = self.viewModel(indexPath: indexPath)
        return vm.isSelectable
    }

    func select(indexPath: IndexPath) {
        let vm = self.viewModel(indexPath: indexPath)
        return vm.select()
    }
}
