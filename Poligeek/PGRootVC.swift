import UIKit

class PGRootVC: UICollectionViewController {

    var flowLayout: UICollectionViewFlowLayout {
        return self.collectionViewLayout as! UICollectionViewFlowLayout
    }

    let profile: PGProfile

    init(profile: PGProfile) {
        self.profile = profile

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = PGUI.margin
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        super.init(collectionViewLayout: flowLayout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: Notification.Name(PGShowsReloadedNotification), object: nil, queue: OperationQueue.main) { (notification) in
            self.collectionView?.reloadData()
        }

        self.collectionView?.register(PGRootShowCell.self, forCellWithReuseIdentifier: NSStringFromClass(PGRootShowCell.self))
        self.collectionView?.backgroundColor = PGUI.backgroundColor

        self.flowLayout.itemSize = self.itemSize(containerSize: UIScreen.main.bounds.size)

        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SFMono-Heavy", size: 24)!,
                                                                        NSForegroundColorAttributeName: PGUI.yellowColor]
        self.title = NSLocalizedString("ui.poligeek", comment: "").localizedUppercase
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func itemSize(containerSize: CGSize) -> CGSize {
        let minItemWidth: CGFloat = containerSize.width > 500 ? 180 : 140
        let availableWidth = containerSize.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right
        let numberOfItems = floor(availableWidth / minItemWidth)

        let width = (availableWidth - (numberOfItems - 1) * self.flowLayout.minimumInteritemSpacing) / CGFloat(numberOfItems)

        let labelHeight = UIFont.preferredFont(forTextStyle: UIFontTextStyleCaption1).lineHeight

        return CGSize(width: width, height: width + labelHeight + PGUI.margin / 2.0)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.flowLayout.itemSize = self.itemSize(containerSize: size)
    }

    // Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profile.shows.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PGRootShowCell.self), for: indexPath)
        guard let castedCell = cell as? PGRootShowCell else { fatalError() }

        let show = self.profile.shows[indexPath.row]
        castedCell.configure(show: show)

        return castedCell
    }

    // Delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = self.profile.shows[indexPath.row]
        let showVM = PGShowVM(show: show)
        let showVC = PGShowVC(showVM: showVM)

        self.navigationController?.pushViewController(showVC, animated: true)
    }
}

