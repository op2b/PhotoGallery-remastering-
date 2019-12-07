
import UIKit

class NewPhotoViewController: UICollectionViewController {
  
        var networkDataFecher = NetworkDataFecther()
        
        private var photosArray = [UnsplahPhoto]()
        private let itemsPerRow : CGFloat = 2
        private let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        private var selectedImages = [UIImage]()
        
        private let reuseIdentifier = "CellId"
        private lazy var addBarButtonItem: UIBarButtonItem = {
            return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
        }()
        private lazy var actionBarButtonItem: UIBarButtonItem = {
            return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
        }()
        
        private var numberOfSelectedPhotos: Int {
            return collectionView.indexPathsForSelectedItems?.count ?? 0
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.backgroundColor = .white
            setUpNabvigationBar()
            setUpCollectionView()
            updateNavigationButtonState()
            getImage()
            
        }
        
        private func updateNavigationButtonState() {
            addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
            actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        }
        
        func refresh() {
            self.selectedImages.removeAll()
            self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
            updateNavigationButtonState()
        }
        
        //MARK: - NAvigationItems Action
        
        @objc private func addBarButtonTapped(sender: UIBarButtonItem) {
            let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (photosss, indexPath) -> [UnsplahPhoto] in
                var mutablePhotos = photosss
                let photo = photosArray[indexPath.item]
                mutablePhotos.append(photo)
                return mutablePhotos
            })

            let alertController = UIAlertController(title: "", message: "\(selectedPhotos!.count) фото будут добавлены в альбом", preferredStyle: .alert)
            let add = UIAlertAction(title: "Добавить", style: .default) { (action) in
                let tabbar = self.tabBarController as! MainTabBarController
                let navVC = tabbar.viewControllers?[2] as! UINavigationController
                let likesVC = navVC.topViewController as! LikesCollectionViewController

                likesVC.photos.append(contentsOf: selectedPhotos ?? [])
                likesVC.collectionView.reloadData()

                self.refresh()
            }
            let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
            }
            alertController.addAction(add)
            alertController.addAction(cancel)
            present(alertController, animated: true)
        }
        
        @objc private func actionButtonTapped(sender: UIBarButtonItem) {
            let sharedController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
            sharedController.completionWithItemsHandler = { _, bool, _, _ in
                if bool {
                    self.refresh()
                }
            }
            sharedController.popoverPresentationController?.barButtonItem = sender
            sharedController.popoverPresentationController?.permittedArrowDirections = .any
            present(sharedController, animated: true, completion: nil)
        }
        
        
        //MARK: - SetUP UIelements

        private func setUpCollectionView() {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            collectionView.register(NewPhotoCell.self, forCellWithReuseIdentifier: NewPhotoCell.reuseId)
            collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            collectionView.contentInsetAdjustmentBehavior = .automatic
            collectionView.allowsMultipleSelection = true
        }
        
        private func setUpNabvigationBar() {
            let titleLable = UILabel()
            titleLable.text = "PHOTOS"
            titleLable.font = UIFont.systemFont(ofSize: 15, weight:  .medium)
            titleLable.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLable)
            navigationItem.rightBarButtonItems = [addBarButtonItem, actionBarButtonItem]
        }
        
        
        //MARK: - UICOllectionViewDataSource and Delegate
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photosArray.count
        }
    
    
     override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         networkDataFecher.networkService.cancel()
     }
     
     override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
         networkDataFecher.networkService.resume()
     }
    
    func getImage() {
        
        self.networkDataFecher.fetchNewImage {[weak self] (searchResults) in
                       guard let fecthPhotos = searchResults else {return}
                       self?.photosArray = fecthPhotos
                       self?.collectionView.reloadData()
                       self?.refresh()
                   }
        
    }
        
       
      
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewPhotoCell.reuseId, for: indexPath) as! NewPhotoCell
            let unsplashPhoto = photosArray[indexPath.item]
            cell.unsplashPhoto = unsplashPhoto
            return cell
        }
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            updateNavigationButtonState()
            let cell = collectionView.cellForItem(at: indexPath) as! NewPhotoCell
            guard let image = cell.photoImageView.image else {return}
            selectedImages.append(image)
        }
        
        override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            updateNavigationButtonState()
            let cell = collectionView.cellForItem(at: indexPath) as! NewPhotoCell
            guard let image = cell.photoImageView.image else {return}
            if let index = selectedImages.firstIndex(of: image) {
                selectedImages.remove(at: index)
            }
        }


    }

 

    //MARK: - UICollectionViewDelegateFlowLayout

    extension NewPhotoViewController: UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let photo = photosArray[indexPath.item]
            let paddingSpace = sectionInset.left * (itemsPerRow + 1)
            let avalibleWidth  = view.frame.width - paddingSpace
            let widthPerItem = avalibleWidth / itemsPerRow
            let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
            return CGSize(width: widthPerItem, height: height)
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInset
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return sectionInset.left
        }
    }
    

