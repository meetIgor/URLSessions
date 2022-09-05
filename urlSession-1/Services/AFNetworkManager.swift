//
//  AFNetworkManager.swift
//  urlSession-1
//
//  Created by igor s on 04.09.2022.
//

import Foundation
import Alamofire

class AFNetworkManager {
    static let shared = AFNetworkManager()
    
    private init() {}
    
    
    
    func fetch<T: Decodable>(type: T.Type, from url: String, completion: @escaping(Result<T, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: T.self) { dataResponse in
                switch dataResponse.result {
                case .success(let type):
                    completion(.success(type))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchAPOD(from url: String, completion: @escaping (Result<[APOD], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let apods = APOD.getApods(from: value)
                    completion(.success(apods))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchApodWithParams(from url: String, completion: @escaping(Result<[APOD2], AFError>) -> Void) {
        let params = [
            "api_key" : "MR1H9Qy8R4s3D1DQhd6h5CvM8WDhfjebftt8CHlv",
            "start_date" : "2022-08-28"
        ]

        AF.request(url, method: .get, parameters: params)
            .validate()
            .responseDecodable(of: [APOD2].self) { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchAPODImage(from url: String,  completion: @escaping(Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func afPostRequest(to url: String, with data: APOD, completion: @escaping(Result<APOD, AFError>) -> Void){
        AF.request(url, method: .post, parameters: data)
            .validate()
            .responseDecodable(of: APOD.self) { dataResponse in
                switch dataResponse.result {
                case .success(let apod):
                    completion(.success(apod))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
