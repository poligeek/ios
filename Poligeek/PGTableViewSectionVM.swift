import Foundation

protocol PGTableViewSectionVMProtocol {
    var numberOfRows: Int { get }

    func viewModel(index: Int) -> PGViewModel

    var headerViewModel: PGViewModel? { get }
    var footerViewModel: PGViewModel? { get }

    func canSelectViewModel(index: Int) -> Bool
    func select(index: Int)
}

class PGTableViewSectionVM: PGTableViewSectionVMProtocol {
    var headerViewModel: PGViewModel?
    var footerViewModel: PGViewModel?

    var viewModels: [PGViewModel]

    init(viewModels: [PGViewModel]) {
        self.viewModels = viewModels
    }

    var numberOfRows: Int {
        return self.viewModels.count
    }

    func viewModel(index: Int) -> PGViewModel {
        return self.viewModels[index]
    }

    func canSelectViewModel(index: Int) -> Bool {
        let vm = self.viewModel(index: index)
        return vm.isSelectable
    }

    func select(index: Int) {
        let vm = self.viewModel(index: index)
        return vm.select()
    }
}
