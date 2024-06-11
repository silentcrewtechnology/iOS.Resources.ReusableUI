//
//  DocumentViewController.swift
// 
//
//  Created by Ilnur Mugaev on 26.04.2024.
//

import UIKit
import SnapKit
import QuickLook
import Components

public class DocumentViewController: UIViewController, QLPreviewControllerDelegate {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var document: DocumentModel
        public var button: ButtonView.ViewProperties
        public var barButton: BarButton
        public var backgroundColor: UIColor
        
        public struct BarButton {
            public var icon: UIImage?
            public var onTap: () -> Void
            
            public init(
                icon: UIImage? = nil,
                onTap: @escaping () -> Void = { }
            ) {
                self.icon = icon
                self.onTap = onTap
            }
        }
        
        public init(
            document: DocumentModel = .init(),
            button: ButtonView.ViewProperties = .init(),
            barButton: BarButton = .init(),
            backgroundColor: UIColor = .clear
        ) {
            self.document = document
            self.button = button
            self.barButton = barButton
            self.backgroundColor = backgroundColor
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var barButtonItem: UIBarButtonItem = {
        let barItem = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: self,
            action: #selector(backTapped))
        return barItem
    }()
    
    private lazy var previewController: QLPreviewController = {
        let vc = QLPreviewController()
        vc.delegate = self
        vc.dataSource = self
        return vc
    }()
    
    private lazy var previewView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var buttonView: ButtonView = {
        let view = ButtonView()
        return view
    }()
    
    // MARK: - Init
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        setupNavBar()
        setupPreviewView()
        setupPreviewController()
        setupButtonView()
    }
    
    // MARK: - Public Method
    
    public func update(with viewProperties: ViewProperties) {
        title = viewProperties.document.previewItemTitle
        barButtonItem.image = viewProperties.barButton.icon?.withRenderingMode(.alwaysOriginal)
        view.backgroundColor = viewProperties.backgroundColor
        buttonView.update(with: viewProperties.button)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func setupPreviewView() {
        view.addSubview(previewView)
        previewView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupPreviewController() {
        addChild(previewController)
        previewView.addSubview(previewController.view)
        previewController.didMove(toParent: self)
        previewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupButtonView() {
        view.addSubview(buttonView)
        buttonView.snp.makeConstraints {
            $0.top.equalTo(previewView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
    }
    
    // MARK: - Action
    
    @objc private func backTapped() {
        viewProperties.barButton.onTap()
    }
}

// MARK: QLPreviewControllerDataSource

extension DocumentViewController: QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return viewProperties.document
    }
}
