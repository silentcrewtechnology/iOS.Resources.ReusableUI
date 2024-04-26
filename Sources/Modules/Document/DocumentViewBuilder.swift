//
//  DocumentViewBuilder.swift
// 
//
//  Created by Ilnur Mugaev on 26.04.2024.
//

import UIKit

public class DocumentViewBuilder {
    
    public typealias V = DocumentViewController
    public typealias U = DocumentViewUpdater
    
    public var view: V
    public var viewUpdater: U
    
    public init(
        view: V = .init(),
        viewUpdater: U = .init()
    ) {
        self.view = view
        self.viewUpdater = viewUpdater
        view.loadViewIfNeeded()
        viewUpdater.bind(view: view)
    }
}
