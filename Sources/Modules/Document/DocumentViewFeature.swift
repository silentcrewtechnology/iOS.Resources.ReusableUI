//
//  DocumentViewFeature.swift
//
//
//  Created by Ilnur Mugaev on 26.04.2024.
//

import UIKit
import SnapKit
import Components

public class DocumentViewFeature {
    
    public typealias V = DocumentViewController
    public typealias U = DocumentViewUpdater
    public typealias B = DocumentViewBuilder
    
    public enum Action {
        case createVC(V.ViewProperties)
        case present
        case dismiss
        case share(DocumentModel)
    }
    
    private var builder: B = .init()
    private var view: V { builder.view }
    private var viewUpdater: U { builder.viewUpdater }
    public var nc: UINavigationController?
    
    public init() { }
    
    public func handle(action: Action) {
        switch action {
        case .createVC(let viewProperties):
            viewUpdater.viewProperties = viewProperties
        case .present:
            present()
        case .dismiss:
            dismiss()
        case .share(let document):
            share(document)
        }
    }
    
    private func present() {
        viewUpdater.handle()
        let navigationController = UINavigationController(rootViewController: view)
        nc?.present(navigationController, animated: true)
    }
    
    private func dismiss(completion: @escaping () -> Void = { }) {
        view.dismiss(animated: true, completion: completion)
    }
    
    private func share(_ document: DocumentModel) {
        guard let url = document.previewItemURL else { return }
        let shareSheet = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        view.present(shareSheet, animated: true)
    }
}
