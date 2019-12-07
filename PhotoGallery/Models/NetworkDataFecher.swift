
import Foundation

class NetworkDataFecther {
    
    var networkService = NetworkService()
    
    func  fetchImage(searchTerm:String, complition: @escaping (SearchResults?) -> ()){
        networkService.request(searchTerm: searchTerm) { (data, error) -> (Void) in
            if let error = error {
                print("Error recive requesting data: \(error.localizedDescription)")
                complition(nil)
            }
            
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            complition(decode)
        }
    }
    
    func  fetchNewImage(complition: @escaping ([UnsplahPhoto]?) -> ()){
           networkService.request() { (data, error) -> (Void) in
               if let error = error {
                   print("Error recive requesting data: \(error.localizedDescription)")
                   complition(nil)
               }
            do {
               let decode = try JSONDecoder().decode([UnsplahPhoto].self, from: data!)
                  complition(decode)
            } catch let error{
                print(error)
            }
             
           }
       }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else {return nil}
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonSeeror {
            print("Failed to decode JSON: \(jsonSeeror)")
            return nil
        }
    }
}
