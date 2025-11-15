//
//  CurrencyModel.swift
//  
//
//  Created by user on 11.06.2024.
//

import Foundation

public struct CurrencyModel: Codable, Equatable {
    public var name: String?
    
    public init(name: String? = nil) {
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}
