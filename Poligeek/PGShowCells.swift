import UIKit

class PGCoverShowCell: PGTableViewCell {
    let coverView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.coverView.translatesAutoresizingMaskIntoConstraints = false
        self.coverView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.coverView)

        self.coverView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.coverView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.coverView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.coverView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.coverView.heightAnchor.constraint(equalTo: self.coverView.widthAnchor).isActive = true
    }

    override func pg_configure(viewModel: PGViewModel) {
        guard let vm = viewModel as? PGShowCoverVM else { return }
        self.coverView.pg_setImage(url: vm.coverURL, placeholder: #imageLiteral(resourceName: "default-cover"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PGTextCell: PGTableViewCell {
	let label = UILabel()
	let detailLabel = UILabel()
	
	let stackView = UIStackView()
	var topConstraint: NSLayoutConstraint? = nil
	var leadingConstraint: NSLayoutConstraint? = nil
	var trailingConstraint: NSLayoutConstraint? = nil
	var bottomConstraint: NSLayoutConstraint? = nil
	
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        self.label.numberOfLines = 0
        self.detailLabel.numberOfLines = 0
	
		self.stackView.translatesAutoresizingMaskIntoConstraints = false
		self.stackView.axis = .vertical
		self.stackView.spacing = 2
		self.stackView.alignment = .fill
		self.stackView.distribution = .equalSpacing
    }

    override func pg_configure(viewModel: PGViewModel) {
        guard let vm = viewModel as? PGTextVM else { return }
		
		self.contentView.addSubview(self.stackView)

		for arrangedSubview in self.stackView.arrangedSubviews {
			self.stackView.removeArrangedSubview(arrangedSubview)
		}
		
		self.leadingConstraint = self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: vm.textInset.left)
		self.topConstraint = self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: vm.textInset.top)
		self.trailingConstraint = self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -vm.textInset.right)
		self.bottomConstraint = self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -vm.textInset.bottom)
		self.bottomConstraint?.priority = UILayoutPriorityDefaultHigh
		
        self.label.text = vm.text
        self.label.font = vm.font
        self.label.textColor = vm.textColor
        self.label.textAlignment = vm.textAlignment
        self.accessoryType = vm.accessory
		
		self.stackView.addArrangedSubview(self.label)

        if let detailText = vm.detailText {
            self.detailLabel.text = detailText
            self.detailLabel.font = vm.detailFont
            self.detailLabel.textColor = vm.detailTextColor
            self.detailLabel.textAlignment = vm.detailTextAlignment
			
			self.stackView.addArrangedSubview(self.detailLabel)
        }
		
		self.leadingConstraint?.isActive = true
		self.topConstraint?.isActive = true
		self.trailingConstraint?.isActive = true
		self.bottomConstraint?.isActive = true
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.stackView.removeFromSuperview()
		self.label.text = nil
		self.detailLabel.text = nil
	}
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PGActionCell: PGTextCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: PGUI.cellHeight).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PGHTMLCell: PGTableViewCell, UIWebViewDelegate, UITextViewDelegate {
    let label = UITextView()
    var heightConstraint: NSLayoutConstraint?
    var viewModel: PGHTMLVM?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.isEditable = false
        self.label.delegate = self
        self.label.contentInset = UIEdgeInsets.zero
        self.label.isScrollEnabled = false
        self.label.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.label)

        self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: PGUI.cellInset.left).isActive = true
        self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: PGUI.cellInset.top).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -PGUI.cellInset.right).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -PGUI.cellInset.bottom).isActive = true

        heightConstraint = self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: PGUI.cellHeight)
        heightConstraint?.isActive = true
    }

    override func pg_configure(viewModel: PGViewModel) {
        guard let vm = viewModel as? PGHTMLVM else { return }
        self.viewModel = vm;

        let html = vm.text.appending("<style>\(self.css())</style>")

        let attributedString = try? NSAttributedString(data: html.data(using: String.Encoding.utf16)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        if let textFrame = attributedString?.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil) {
            heightConstraint?.constant = textFrame.height
        }

        self.label.attributedText = attributedString
    }

    func css() -> String {
        return "*{font-family:-apple-system;} body{color:\(UIColor.darkText.pg_hexCode); font-size: 12pt;} h2{font-size:1em;} a{color:\(PGUI.tintColor.pg_hexCode);}}}"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.viewModel?.hypertextLinkSelected?(URL)
        return false
    }
}

