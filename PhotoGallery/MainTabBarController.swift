
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let photoVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let likesVC = LikesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [generateNavigationController(rootViewControlelr: photoVC, title: "Photos", image: UIImage(named: "photos")!), generateNavigationController(rootViewControlelr: likesVC, title: "Favorites" , image: UIImage(named: "star")!)]
    }
    
    private func generateNavigationController(rootViewControlelr: UIViewController, title: String, image: UIImage) -> UIViewController{
        let navigationVC = UINavigationController(rootViewController: rootViewControlelr)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}

