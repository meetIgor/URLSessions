//
//  NetworkManager.swift
//  URLSessions
//
//  Created by igor s on 03.09.2022.
//

import Foundation

enum Link: String {
    case margaritaURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita"
    case imageURL = "https://apod.nasa.gov/apod/image/2209/TulipCygX-1.jpg"
    case searchURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php"
    case postRequest = "https://jsonplaceholder.typicode.com/posts"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
//    func fetchImage(from url: String?, completion: @escaping (Data) -> Void) {
//        guard let url = URL(string: url ?? "") else { return }
//        DispatchQueue.global().async {
//            guard let imageData = try? Data(contentsOf: url) else { return }
//            DispatchQueue.main.async {
//                completion(imageData)
//            }
//        }
//    }
    
    func fetchImage(from url: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
//    func fetchDrinks(from url: String?, completion: @escaping(Result<Drink, NetworkError>) -> Void) {
//        guard let url = URL(string: url ?? "") else {
//            completion(.failure(.invalidURL))
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data else {
//                completion(.failure(.noData))
//                return
//            }
//
//            do {
//                let drinks = try JSONDecoder().decode(Drink.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(drinks))
//                }
//            } catch {
//                completion(.failure(.decodingError))
//            }
//        }.resume()
//    }
    
    func fetch<T: Decodable> (_ type: T.Type, from url: String?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func postRequest(with data: [String: Any], to url: String?, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else  { return }
        
        let drinkData = try? JSONSerialization.data(withJSONObject: data)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = drinkData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            print(response)
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data)
                completion(.success(jsonData))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func postRequestWithModel(with data: Drink, to url: String?, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else  { return }
        
        guard let drinkData = try? JSONEncoder().encode(data) else {
            completion(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = drinkData
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let drinks = try JSONDecoder().decode(Drink.self, from: data)
                completion(.success(drinks))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchAPOD<T: Decodable> (_ type: T.Type, from url: String?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
//    func fetchAPODWithParam<T: Decodable> (_ type: T.Type, from url: String?, completion: @escaping (Result<T, NetworkError>) -> Void) {
//        guard let url = URL(string: url ?? "") else {
//            completion(.failure(.invalidURL))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.addValue("MR1H9Qy8R4s3D1DQhd6h5CvM8WDhfjebftt8CHlv", forHTTPHeaderField: "api_key")
//        request.addValue("2022-08-28", forHTTPHeaderField: "start_date")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "no description")
//                completion(.failure(.noData))
//                return
//            }
//            print(response)
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let type = try decoder.decode(T.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(type))
//                }
//            } catch {
//                completion(.failure(.decodingError))
//            }
//        }.resume()
//    }
}
