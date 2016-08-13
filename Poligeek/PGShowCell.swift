import UIKit

class PGRootShowCell: UICollectionViewCell {

    let coverView = UIImageView()
    let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.coverView.image = UIImage(named: "cover")
        self.coverView.translatesAutoresizingMaskIntoConstraints = false
        self.coverView.layer.cornerRadius = 3
        self.coverView.layer.masksToBounds = true
        self.coverView.backgroundColor = UIColor(white: 0, alpha: 0.1)

        self.dateLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleCaption1)
        self.dateLabel.textColor = UIColor.lightGray
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.coverView)
        self.addSubview(self.dateLabel)

        self.coverView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.coverView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.coverView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.coverView.widthAnchor.constraint(equalTo: self.coverView.heightAnchor).isActive = true

        self.dateLabel.topAnchor.constraint(equalTo: self.coverView.bottomAnchor, constant: PGUI.margin / 2.0).isActive = true
        self.dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(white: 0, alpha: 0.1)
    }

    func configure(show: PGShow) {
        self.dateLabel.text = show.releaseDate.pg_mediumDate()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
