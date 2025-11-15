//
//  StockModel.swift
//
//
//  Created by user on 11.06.2024.
//

import Foundation

public struct StockModel: Codable, Equatable {
    public var instrumentId: Int?
    public var name: String?
    public var price: Decimal?
    public var currency: CurrencyModel?
    public var imageUrl: String?
    public var securcode: String?
    public var priceDynamics: Decimal?
    public var priceDynamicsInPercent: Decimal?
    
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
    
    public init(
        instrumentId: Int? = nil,
        name: String? = nil,
        price: Decimal? = nil,
        currency: CurrencyModel? = nil,
        imageUrl: String? = nil,
        securcode: String? = nil,
        priceDynamics: Decimal? = nil,
        priceDynamicsInPercent: Decimal? = nil
    ) {
        self.instrumentId = instrumentId
        self.name = name
        self.price = price
        self.currency = currency
        self.imageUrl = imageUrl
        self.securcode = securcode
        self.priceDynamics = priceDynamics
        self.priceDynamicsInPercent = priceDynamicsInPercent
    }
    
    public static func == (lhs: StockModel, rhs: StockModel) -> Bool {
        return lhs.instrumentId == rhs.instrumentId
            && lhs.name == rhs.name
            && lhs.price == rhs.price
            && lhs.imageUrl == rhs.imageUrl
            && lhs.securcode == rhs.securcode
            && lhs.priceDynamics == rhs.priceDynamics
            && lhs.priceDynamicsInPercent == rhs.priceDynamicsInPercent
            && lhs.currency == rhs.currency
    }
}
