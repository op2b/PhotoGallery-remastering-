
import Foundation

class NetworkService {
    
    var dataTask: URLSessionDataTask?
    
    // построение запросов дланных через url
    func request(searchTerm: String, complition: @escaping (Data?, Error?) -> (Void)) {
        let parameters = self.prepeareParameters(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepeareHeaders()
        request.httpMethod = "GET"
        dataTask = createDataTask(from: request, complition: complition)
        dataTask?.resume()
    }
    
    func request(complition: @escaping (Data?, Error?) -> (Void)) {
           let parameters = self.prepeareParameters()
           let url = self.url2(params: parameters)
           var request = URLRequest(url: url)
           request.allHTTPHeaderFields = prepeareHeaders()
           request.httpMethod = "GET"
           let task = createDataTask(from: request, complition: complition)
           task.resume()
       }
    
    func cancel() {
        dataTask?.cancel()
    }
    
    func resume() {
        dataTask?.resume()
    }
    
    private func prepeareHeaders() -> [String : String]? {
    
        var headers = [String : String]()
        headers["Authorization"] = "Client-ID 546c78d38cb9b6f669bd40f2802aee96fc0b97856bca2914192f97c28ee03f06"
        return headers
        
    }
    
    private func prepeareParameters(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        return parameters
        
    }
    
    private func prepeareParameters() -> [String: String] {
           var parameters = [String: String]()
           parameters["page"] = String(1)
           parameters["per_page"] = String(30)
           return parameters
       }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map{URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func url2(params: [String: String]) -> URL {
         var components = URLComponents()
         components.scheme = "https"
         components.host = "api.unsplash.com"
         components.path = "/photos"
         components.queryItems = params.map{URLQueryItem(name: $0, value: $1)}
         return components.url!
     }
    
    
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                complition(data,error)
            }
        })
    }
    
}
