//
//  APIClient.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

/**
 Cheet sheet
 https://codewithchris.com/alamofire/
 */

import Foundation
import Alamofire
import SwiftyJSON


public enum Result<T> {
    case success(T)
    case failure(ErrorResponse)
}

typealias CompletionHandler<T> = (Result<T>) -> ()
public typealias ErrorResponse = (Int, Data?, Error)
typealias ResponseCompletion<T> = (Result<T>) -> ()


class APIClient {
    //static let shared = APIClient()
    private static var privateShared : APIClient?
    
    class var shared: APIClient {
        guard let uwShared = privateShared else {
            privateShared = APIClient()
            return privateShared!
        }
        return uwShared
    }
    
    class func destroy() {
        privateShared = nil
    }
    
    private init() {}
    
    deinit {
        print("deinit singleton")
    }
    
    func mrHeaders(url: String) -> HTTPHeaders {
        let header: HTTPHeaders = ["Content-Type" : "application/x-www-form-urlencoded", "Accept" : "application/json"]
        return header
    }
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        /*
         This configuration is the same as URLSessionConfiguration.default,
         but also includes Alamofire's default headers.
         */
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        
        // Authorization header added in AFRequestInterceptor class
        let afInterceptor = AFRequestInterceptor(token: "")
        
        #if DEBUG
        return Session(configuration: configuration, interceptor: afInterceptor, eventMonitors: [AFRequestMonitor()])
        #else
        return Session(configuration: configuration, interceptor: afInterceptor)
        #endif
        
        
    }()
}

extension APIClient {
    /// Returns a specific Object or Error
    func objectAPICall<T: Decodable>(apiEndPoint: Endpoint, modelType: T.Type,
                                     completion: @escaping CompletionHandler<T>) {
        sessionManager.request(apiEndPoint.path, method: apiEndPoint.method, parameters: apiEndPoint.query, encoding: apiEndPoint.encoding, headers: mrHeaders(url: apiEndPoint.path))
            .validate(statusCode: 200..<300)
            .responseDecodable { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    completion(Result.success(value))
                case .failure(let error):
                    print(error.localizedDescription)
                    guard let statusCode = response.response?.statusCode else {
                        let unKnownError = ErrorResponse(-999, response.data, error)
                        completion(Result.failure(unKnownError))
                        return
                    }
                    let mError = ErrorResponse(statusCode, response.data, error)
                    let json = JSON(response.data ?? Data())
                    let msg = json["error"]["message"].stringValue
                    Helper.showAlert(msg: msg)
                    completion(Result.failure(mError))
                }
        }
    }
    
    /// Returns array of specific Object or Error
    func arrayObjectAPICall<T: Decodable>(apiEndPoint: Endpoint, modelType: T.Type, completion: @escaping CompletionHandler<[T]>) {
        sessionManager.request(apiEndPoint.path, method: apiEndPoint.method, parameters: apiEndPoint.query, encoding: apiEndPoint.encoding)
            //.debugLog()
            .validate(statusCode: 200..<300)
            .responseDecodable { (response: AFDataResponse<[T]>) in
                switch response.result {
                case .success(let value):
                    completion(Result.success(value))
                case .failure(let error):
                    print(error.localizedDescription)
                    guard let statusCode = response.response?.statusCode else {
                        let unKnownError = ErrorResponse(-999, response.data, error)
                        completion(Result.failure(unKnownError))
                        return
                    }
                    let mError = ErrorResponse(statusCode, response.data, error)
                    let json = JSON(response.data ?? Data())
                    let msg = json["error"]["message"].stringValue
                    Helper.showAlert(msg: msg)
                    completion(Result.failure(mError))
                }
        }
    }
    
    /// Returns JSON or Error
    func makeAPICall(apiEndPoint: Endpoint, completion: @escaping CompletionHandler<Any>) {
        sessionManager.request(apiEndPoint.path, method: apiEndPoint.method, parameters: apiEndPoint.query, encoding: apiEndPoint.encoding, headers: mrHeaders(url: apiEndPoint.path))
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completion(Result.success(value))
                case .failure(let error):
                    print(error.localizedDescription)
                    guard let statusCode = response.response?.statusCode else {
                        let unKnownError = ErrorResponse(-999, response.data, error)
                        completion(Result.failure(unKnownError))
                        return
                    }
                    let mError = ErrorResponse(statusCode, response.data, error)
                    let json = JSON(response.data ?? Data())
                    let msg = json["error"]["message"].stringValue
                    Helper.showAlert(msg: msg)
                    completion(Result.failure(mError))
                }
        }
    }
    
    func checkMockdata<T: Decodable>(fileName: String, modelType: T.Type, completion: @escaping CompletionHandler<T>) {
        guard let jsonData = Helper.loadJSON(jsonFileName: fileName) else {return}
        
        let decoder = JSONDecoder()
        let list = try! decoder.decode(modelType.self, from: jsonData)
        completion(Result.success(list))
    }
    
}
