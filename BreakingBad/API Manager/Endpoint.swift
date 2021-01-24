//
//  Endpoint.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import Foundation
import Alamofire

/**
 *  Protocol for all endpoints to conform to.
 */
protocol Endpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [String: Any] { get }
    var encoding: ParameterEncoding { get }
}

extension Endpoint {
    var encoding: ParameterEncoding { get{return URLEncoding.default} set {} }
}
