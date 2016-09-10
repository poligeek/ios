import UIKit

class PGTableViewController: UITableViewController {
    let tableViewVM: PGTableViewVM

    var viewModelViewAssociation: [String : UIView.Type] = [:]
    var viewModelsBackgroundColors: [String : UIColor]?

    init(viewModel: PGTableViewVM, style: UITableViewStyle) {
        self.tableViewVM = viewModel
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.tableViewVM.title

        self.tableView.estimatedRowHeight = PGUI.cellHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = PGUI.backgroundColor

        for register in self.viewModelViewAssociation.values {
            self.tableView.pg_register(class: register)
        }

        if self.viewModelsBackgroundColors == nil {
            self.tableView.separatorInset = UIEdgeInsets.zero
        } else {
            self.tableView.separatorStyle = .none
        }

        if let tableHeaderView = self.headerFooterView(viewModel: self.tableViewVM.headerViewModel) {
            self.tableView.tableHeaderView = tableHeaderView
        }
        if let tableFooterView = self.headerFooterView(viewModel: self.tableViewVM.footerViewModel) {
            self.tableView.tableFooterView = tableFooterView
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.tableView.reloadData()
    }

    // Data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return PGUI.tableViewSectionHeaderHeight
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return PGUI.tableViewSectionFooterHeight
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewVM.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewVM.numberOfRows(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.tableViewVM.viewModel(indexPath: indexPath)
        guard let cellClass = self.viewModelViewAssociation[viewModel.vmType] else { fatalError() }

        let cell = self.tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(cellClass), for: indexPath)

        if let castedCell = cell as? PGTableViewCell {
            castedCell.pg_configure(viewModel: viewModel)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = self.tableViewVM.headerViewModel(forSection: section) else { return nil }
        guard let headerClass = self.viewModelViewAssociation[viewModel.vmType] else { fatalError() }

        guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(headerClass)) else { return nil }
        let sel = #selector(PGViewProtocol.pg_configure(viewModel:))
        if header.responds(to: sel) {
            _ = header.perform(sel, with: viewModel)
        }
        return header
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let viewModel = self.tableViewVM.footerViewModel(forSection: section) else { return nil }
        guard let footerClass = self.viewModelViewAssociation[viewModel.vmType] else { fatalError() }

        guard let footer = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(footerClass)) else { return nil }
        let sel = #selector(PGViewProtocol.pg_configure(viewModel:))
        if footer.responds(to: sel) {
            _ = footer.perform(sel, with: viewModel)
        }
        return footer
    }

    // Cell display

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let colors = self.viewModelsBackgroundColors {
            let viewModel = self.tableViewVM.viewModel(indexPath: indexPath)

            if let color = colors[viewModel.vmType] {
                cell.backgroundColor = color
                cell.backgroundView = nil
            } else {
                cell.backgroundColor = nil
                cell.backgroundView = nil
                cell.separatorInset = UIEdgeInsets(top: 0, left: CGFloat.infinity, bottom: 0, right: 0)
            }
        }
    }

    // Cell selection

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return self.tableViewVM.canSelectViewModel(indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableViewVM.select(indexPath: indexPath)
    }

    // VM

    func headerFooterView(viewModel: PGViewModel?) -> UIView? {
        guard let viewModel = viewModel else { return nil }
        let headerFooterClass = self.viewModelViewAssociation[viewModel.vmType]
        guard let headerFooterView = headerFooterClass?.init() else { return nil }


        let sel = #selector(PGViewProtocol.pg_configure(viewModel:))
        if headerFooterView.responds(to: sel) {
            _ = headerFooterView.perform(sel, with: viewModel)
        }

        return headerFooterView
    }
}
