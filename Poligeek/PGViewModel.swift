import Foundation

protocol PGViewModelProtocol {
    var vmType: String { get }
    var isSelectable: Bool { get }

    func select()
}

class PGViewModel: NSObject, PGViewModelProtocol {
    var vmType: String = ""
    var isSelectable: Bool = false

    func select() { }
}
