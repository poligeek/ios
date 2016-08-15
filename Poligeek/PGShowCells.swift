import UIKit

class PGCoverShowCell: PGTableViewCell {
    let coverView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.coverView.translatesAutoresizingMaskIntoConstraints = false
        self.coverView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.coverView)

        self.coverView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: PGUI.cellInset.left).isActive = true
        self.coverView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.coverView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -PGUI.cellInset.right).isActive = true
        self.coverView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.coverView.heightAnchor.constraint(equalTo: self.coverView.widthAnchor).isActive = true
    }

    override func pg_configure(viewModel: PGViewModel) {
        self.coverView.image = UIImage(named: "cover")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PGTextCell: PGTableViewCell {
    let label = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.numberOfLines = 0
        self.contentView.addSubview(self.label)

        self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: PGUI.cellInset.left).isActive = true
        self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: PGUI.cellInset.top).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -PGUI.cellInset.right).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -PGUI.cellInset.bottom).isActive = true

        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: PGUI.cellHeight).isActive = true
    }

    override func pg_configure(viewModel: PGViewModel) {
        guard let vm = viewModel as? PGTextVM else { return }

        self.label.text = vm.text
        self.label.font = vm.font
        self.label.textColor = vm.textColor
        self.label.textAlignment = vm.textAlignment
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
