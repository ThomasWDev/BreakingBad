//
//  APIEndpoints.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


//MARK:- Dashboard
enum CharecterDataEndPoint: Endpoint {
    
    case getCharacterData
    
    var method: HTTPMethod {
        switch self {
        case .getCharacterData:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getCharacterData:
            return KBasePath + OauthPath.getCharacterData.rawValue
        }
    }
    
    var query: [String: Any]  {
        switch self {
        case .getCharacterData:
            return [String: Any]()
        }
    }
}
