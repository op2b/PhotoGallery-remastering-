
import UIKit

class PhotosCollectionViewController: UICollectionViewController{
    
    
    var networkDataFecher = NetworkDataFecther()
    private var timer: Timer?
    
    private let reuseIdentifier = "Cell"
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(addBarButtonAdd))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .orange
        setUpNabvigationBar()
        setUpCollectionView()
        setUPSearchBar()
        
    }
    
    //MARK: - NAvigationItems Action
    
    @objc private func addBarButtonTapped() {
        print(#function)
    }
    
    @objc private func addBarButtonAdd() {
        print(#function)
    }
    
    
    //MARK: - SetUP UIelements

    private func setUpCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func setUpNabvigationBar() {
        let titleLable = UILabel()
        titleLable.text = "PHOTOS"
        titleLable.font = UIFont.systemFont(ofSize: 15, weight:  .medium)
        titleLable.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLable)
        navigationItem.rightBarButtonItems = [addBarButtonItem, actionBarButtonItem]
    }
    
    private func setUPSearchBar() {
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
       
        
    }
    
    //MARK: - UICOllectionViewDataSource and Delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
   
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    


}

extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFecher.fetchImage(searchTerm: searchText) { (searchResults) in
                searchResults?.results.map({ (photo) in
                    print(photo.urls["small"])
                })
            }
        })
        }
    }
    


