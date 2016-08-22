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
        guard let vm = viewModel as? PGShowCoverVM else { return }
        self.coverView.pg_setImage(url: vm.coverURL, placeholder: #imageLiteral(resourceName: "default-cover"))
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

class PGHTMLCell: PGTableViewCell, UIWebViewDelegate {
    let webView = UIWebView(frame: CGRect.zero)
    var webViewConstraint: NSLayoutConstraint

    var viewModel: PGHTMLVM?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.webViewConstraint = self.webView.heightAnchor.constraint(equalToConstant: 200)
        self.webViewConstraint.isActive = true

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.webView.delegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.scrollView.isScrollEnabled = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.scrollView.backgroundColor = UIColor.clear

        self.contentView.addSubview(self.webView)

        self.webView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: PGUI.cellInset.left).isActive = true
        self.webView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: PGUI.cellInset.top).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -PGUI.cellInset.right).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -PGUI.cellInset.bottom).isActive = true

        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: PGUI.cellHeight).isActive = true
    }

    override func layoutSubviews() {
    }

    override func pg_configure(viewModel: PGViewModel) {
        guard let vm = viewModel as? PGHTMLVM else { return }

        self.viewModel = vm

        self.webView.loadHTMLString(self.webView.pg_encapsulate(html: vm.text), baseURL: nil)
        self.webViewConstraint.constant = self.webView.scrollView.contentSize.height

        self.setNeedsLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // WebView Delegate

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url else { return false }

        if url.absoluteString == "about:blank" || navigationType == .other {
            return true
        }

        self.viewModel?.hypertextLinkSelected?(url)

        return false
    }
}

