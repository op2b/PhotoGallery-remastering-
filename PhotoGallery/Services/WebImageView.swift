
import UIKit

class WebImageView: UIImageView {
    
    func set(imageUrl:String) {
        
        guard let url = URL(string: imageUrl) else { return }
        
        if let cached = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cached.data)
            return
        }
        
      
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, erroe) in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.image = UIImage(data: data)
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        
        guard let responseURL = response.url else {return}
        let caheResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(caheResponse, for: URLRequest(url: responseURL))
        
    }
    
}
