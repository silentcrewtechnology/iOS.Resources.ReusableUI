//
//  CurrencyModel.swift
//  
//
//  Created by user on 11.06.2024.
//

import Foundation

public struct CurrencyModel: Decodable {
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}
