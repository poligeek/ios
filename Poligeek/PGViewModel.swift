import Foundation

protocol PGViewModelProtocol {
    var vmType: String { get }

    func isSelectable() -> Bool
    func select()
}

class PGViewModel: NSObject, PGViewModelProtocol {
    var vmType: String = ""

    func isSelectable() -> Bool { return false }
    func select() { }
}
