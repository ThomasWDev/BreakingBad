//
//  AFRequestInterceptor.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import Foundation
import Alamofire

final class AFRequestInterceptor: Alamofire.RequestInterceptor {
    
    private var accessToken: String
    
    // https://github.com/Alamofire/Alamofire/issues/2998
    typealias AdapterResult = Swift.Result<URLRequest, Error>
    
    init(token:String) {
        self.accessToken = token
    }
    
//    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AdapterResult) -> Void) {
//        
//        //path where authorization header is not needed
//        let signinPath = OauthPath.signin.rawValue
//        let loginPath = OauthPath.fb_authenticate.rawValue
//        
//        guard let urlStr = urlRequest.url?.absoluteString,
//            urlStr.hasPrefix(KBasePath),
//            !urlStr.hasSuffix(signinPath),
//            !urlStr.hasSuffix(loginPath)
//            else {
//                /// If the request does not require authentication, we can directly return it as unmodified.
//                return completion(.success(urlRequest))
//        }
//        
//        var modifiedUrlRequest = urlRequest
//        /// Set the Authorization header value using the access token.
//        DLog("*** Addidng access token ***")
//        modifiedUrlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        
//        completion(.success(modifiedUrlRequest))
//    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, let errorCode = APIError(rawValue: response.statusCode) else {
            /// The request did not fail due to a 401 Unauthorized response.
            /// Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }
        
        switch errorCode {
        case .unauthorized:
            print("******** Get Access Token ********")
            return completion(.doNotRetry)
            
        case .timeOut:
            print("******** REQUEST TIME OUT ********")
            print("Retry Count = \(request.retryCount)")
            print("requested URL = \(String(describing: response.url))")
            if request.retryCount == 3 {
                return completion(.doNotRetry) }
            return completion(.retryWithDelay(1.0)) // retry after 1 second
        case .invalidParam:
            print("************ ============ ************")
            print("******* WRONG PARAMETER SEND TO API *******")
            completion(.doNotRetry)
        case .notFound:
            print("************ ============ ************")
            print("******* NOT FOUND IN SERVER *******")
            completion(.doNotRetry)
        case .dependencyFail:
            print("************ ============ ************")
            print("******* BACKEND FAILD FOR DEPENDENCY *******")
            completion(.doNotRetry)
        case .serverProblem:
            print("************ ============ ************")
            print("******* BACKEND INTERNAL SERVER PROBLEM *******")
            completion(.doNotRetry)
        case .preconditioned:
            print("************ ============ ************")
            print("******* PRE CONDITION FAILED *******")
            completion(.doNotRetry)
        }
        
        
    }
}


/**
 use the bellow code, if refresh token mechanism needs to implement
 use the refreshToken method only
 if unauthorized request (401)
 */

/**
// Get the access token, and retry the api call
refreshToken { [weak self] result in
    guard let self = self else { return }

    switch result {
    case .success(let token):
        self.accessToken = token
        /// After updating the token we can safily retry the original request.
        completion(.retry)
    case .failure(let error):
        completion(.doNotRetryWithError(error))
    }
}
*/

/**
 private func refreshToken(_ completion:@escaping CompletionHandler<Any>) {
     // Here call the api to get access token.
     // set isRefreshing = false in api completion block
 }
 */

