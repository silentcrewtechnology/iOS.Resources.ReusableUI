//
//  DocumentViewUpdater.swift
//
//
//  Created by Ilnur Mugaev on 26.04.2024.
//

import UIKit

public class DocumentViewUpdater {
    
    public typealias V = DocumentViewController
    
    public var update: (V.ViewProperties) -> Void = { _ in }
    public var viewProperties: V.ViewProperties = .init()
    
    public init() { }
    
    public func bind(view: V) {
        update = { [weak self, weak view] viewProperties in
            guard let self, let view else { return }
            self.viewProperties = viewProperties
            view.update(with: self.viewProperties)
        }
    }
    
    public func handle() {
        update(viewProperties)
    }
}
