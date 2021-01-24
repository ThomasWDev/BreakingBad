//
//  CharecterResponse.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import Foundation

class CharecterResponse: Decodable, CustomStringConvertible {
    var description: String{
        return ""
    }
    
    var charId: Int?
    var name: String?
    var birthday: String?
    var occupationList: [String]?
    var img: String?
    var status: String?
    var nickname: String?
    var portrayed: String?
    var category: String?
    var appearance: [Int]?

    enum CodingKeys: String, NestableCodingKey {
        case charId = "char_id"
        case name = "name"
        case birthday = "birthday"
        case img = "img"
        case status = "status"
        case nickname = "nickname"
        case portrayed = "portrayed"
        case category = "category"
        case occupationList = "occupation"
        case appearance = "appearance"
    }
}
