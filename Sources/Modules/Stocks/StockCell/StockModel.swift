//
//  StockModel.swift
//
//
//  Created by user on 11.06.2024.
//

import Foundation

public struct StockModel: Decodable {
    var instrumentId: Int?
    var name: String?
    var price: Decimal?
    var currency: CurrencyModel?
    var imageUrl: String?
    var securcode: String?
    var priceDynamics: Decimal?
    var priceDynamicsInPercent: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case instrumentId = "InstrumentId"
        case name = "Name"
        case price = "Price"
        case currency = "Currency"
        case imageUrl = "ImageUrl"
        case securcode = "Securcode"
        case priceDynamics = "PriceDynamics"
        case priceDynamicsInPercent = "PriceDynamicsInPercent"
    }
}
