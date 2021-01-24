//
//  URLPaths.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import Foundation


#if DEVELOPMENT
let KBasePath = "https://breakingbadapi.com"
#else
let KBasePath = "https://breakingbadapi.com"
#endif

enum OauthPath: String {
    
    case getCharacterData             = "/api/characters"
}
