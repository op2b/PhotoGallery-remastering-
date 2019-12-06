
import Foundation
import UIKit


class LikesCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "LikesCollectionViewCell"
    
    private let checkMark: UIImageView = {
        let image = UIImage(named: "bird1")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            updateState()
        }
    }
    
   
    
    var myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        return imageView
    }()
    
    var unsplashPhoto: UnsplahPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"] 
            guard let imageUrl = photoUrl else { return }
            myImageView.set(imageUrl: imageUrl)
            
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
        setupImageView()
        setUpCheckMArkView()
        updateState()
    
    }
    
    private func updateState() {
        myImageView.alpha = isSelected ? 0.7 : 1
        checkMark.alpha = isSelected ? 1 : 0
    }
    
    private func setUpCheckMArkView() {
        addSubview(checkMark)
        checkMark.trailingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: -8).isActive = true
        checkMark.bottomAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: -8).isActive = true
      }
    
    func setupImageView() {
        addSubview(myImageView)
        myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        myImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        myImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func set(photo: UnsplahPhoto) {
        let photoUrl = photo.urls["full"]
        guard let photoURL = photoUrl else { return }
        myImageView.set(imageUrl: photoURL)
    }
    
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
