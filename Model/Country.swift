//
//  Country.swift
//  Funzy
//
//  Created by Ishipo on 23/08/2021.
//

import Foundation

struct Country: Codable {
    var name : String
    var dial_code : String
    var image : String
    
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case dial_code = "dial_code"
        case image = "code"
    }

}




