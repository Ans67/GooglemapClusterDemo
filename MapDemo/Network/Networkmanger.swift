//
//  Networkmanger.swift
//  MapDemo
//
//  Created by ANAS MANSURI on 27/06/2021.
//

import Foundation

public typealias Parameters = Data? // params
public typealias HTTPHeaders = [String: String] // headers

public enum HTTPMethod : String{
    case get = "GET"
    case post = "post"
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}

class NetworkManger{
    
    static let sharedInstance = NetworkManger()
    
    private init(){}
    
    // Send Request
    public func sendRequest<T: Decodable>(for: T.Type = T.self,
                                          url: String,
                                          method: HTTPMethod,
                                          headers: HTTPHeaders? = nil,
                                          body: Parameters? = nil,
                                          completion: @escaping (Result<T>) -> Void) {

        return sendRequest(url, method: method, headers: headers, body:body) { data, response, error in
            guard let data = data else {
                return completion(.failure(error ?? NSError(domain: "SomeDomain", code: -1, userInfo: nil)))
            }
            do {
                let decoder = JSONDecoder()
                try completion(.success(decoder.decode(T.self, from: data)))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
    }
    
    
    public func sendRequest(_ url: String,
                            method: HTTPMethod,
                            headers: HTTPHeaders? = nil,
                            body: Parameters? = nil,
                            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = URL(string: url)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
       
       // urlRequest.httpBody = data //try? JSONSerialization.data(withJSONObject: parameters)
        
        if let headers = headers {
            urlRequest.allHTTPHeaderFields = headers
            //  urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        if let body = body {
            urlRequest.httpBody = body
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            completionHandler(data, response, error)
        }
        
        task.resume()
    }
    

    
}


/*

private func getAllCompayDataAPI(){
     
     let urlval = "https://myscrap.com/api/msDiscoverPage"
     let headers = [
         "Content-Type": "application/x-www-form-urlencoded",
         "Accept": "application/json"
     ]
     
     let data : Data = "searchText=\("")&apiKey=501edc9e".data(using: .utf8, allowLossyConversion: false)!
     let url = URL(string: urlval)!
     var urlRequest = URLRequest(url: url)
     urlRequest.httpMethod = RequestMethod.post.rawValue
    
     urlRequest.allHTTPHeaderFields = headers
     urlRequest.httpBody = data //try? JSONSerialization.data(withJSONObject: parameters)
     
     
     let session = URLSession(configuration: .default)
     let task = session.dataTask(with: urlRequest) { data, response, error in
         
         
         if let error = error
         {
             print(error)
         }
         else if let response = response {
             print("her in resposne", response)
             
         }else if let data = data
         {
             print("here in data")
             print(data)
         }
         
         DispatchQueue.main.async { // Correct
             
             guard let responseData = data else {
                 print("Error: did not receive data")
                 return
             }
             
             let decoder = JSONDecoder()
     
             do {
                 
                 let modelData = try decoder.decode(BaseModel.self, from: responseData)
                 self.locationData = modelData.locationData ?? []
                 
                 
                 DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                     if self.locationData.count > 0{
                         self.setupGoogleMap(locationArray: self.locationData)
                     }
                 }
                 
                 print(modelData)
             } catch {
                 print("error trying to convert data to JSON")
             }
         }
         
     }
     
     task.resume()
     
 }
*/
