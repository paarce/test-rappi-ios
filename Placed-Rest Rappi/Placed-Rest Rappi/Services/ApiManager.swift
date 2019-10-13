//
//  ApiManager.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/12/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import Foundation
import Moya

let provider = MoyaProvider<Api>()


enum Api {
    case search( lat : Double, log : Double, count : Int)
    
}


extension Api: TargetType {
    
    var headers: [String : String]? {
        
        let apiKey = "dbc6b4cb044a5da3534a920f335a8dd6"
        
        return ["Content-type": "application/json",
                "user-key" : apiKey]
    }
    
    
    var baseURL: URL { return URL(string: "https://developers.zomato.com/api/v2.1/")! }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .search:
            return "search"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .search
            :
            return .get
            
        }
        
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
    
        switch self {
        case .search(let lat, let log, let count):
            let parameters : [String : Any] = [
                "lat": lat,
                "lon": log,
                "count": count
                ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
         
    }
    
    static func request<T: Codable>(endpoint : Api, completationBool: ((Result<Bool,ErrorApi>) -> Void)? = nil, completation: ((Result<T,ErrorApi>) -> Void)? = nil)  {
        //print(endpoint.baseURL.absoluteString+endpoint.path)
        provider.rx.request(endpoint).subscribe { event in
            switch event {
            case let .success(response):
                switch response.statusCode{
                case 200...299:
                    //response.printToString()
                    if let completationBool = completationBool {
                        completationBool(.success(true))
                    }else if let completation = completation {
                        
                        do {
                            let data = try JSONDecoder().decode(T.self, from: response.data)
                            completation(.success(data))
                        }
                        catch (let error) {
                            print(error)
                            completation(.failure(.Error(ErrorModel(statusCode: 400, message: "Some went wrong"))))
                        }
                        
                    }else {
                        completation?(.failure(.Error(ErrorModel(statusCode: 400, message: "Some went wrong"))))
                    }
                    
                default:
                    let msg = String(data: response.data, encoding: String.Encoding.utf8) as String?
                    let ErrorMap = ErrorModel(statusCode: response.statusCode, message: msg)
                    completation?(.failure(.Error(ErrorMap)))
                    completationBool?(.failure(.Error(ErrorMap)))
               
                    break
                }
                
            case let .error(error):
                print(error)
            }
            }
            .disposed(by: disposbag)
    }
    
}

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

extension Response {
    
    func printToString() {
        let jsonReponse = try? self.mapJSON()
        let jsontest = jsonReponse as? [String: Any]
        print(jsontest as Any)
    }
    
}


