//
//  StocksListFilterModel.swift
//
//
//  Created by user on 11.06.2024.
//

import Foundation

public struct StocksListFilterModel {
    public var filterType: StocksListFilterType
    public var title: String
    
    public static let all = Self(filterType: .all, title: "Все")
    public static let ru = Self(filterType: .ru, title:  "Российские")
    public static let other = Self(filterType: .other, title: "Иностранные")
    
    public init(filterType: StocksListFilterType, title: String) {
        self.filterType = filterType
        self.title = title
    }
}
