//
//  EsiaWebAuthorizationVC.swift
//  ABOL
//
//  Created by Eduard Sergeev on 14.05.2021.
//  Copyright © 2021 ps. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import ImagesService

public final class EsiaWebAuthorizationVC: UIViewController {
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    // TODO: Вынести BOKStateOverlayView в пакет
//    private let overlay = BOKStateOverlayView()
    
    private lazy var webView: WKWebView = {
        var webView = WKWebView(frame: .zero, configuration: .init())
        webView.navigationDelegate = self
        view.addSubview(webView)
        return webView
    }()
    
    private let onComplete: ([String: String]) -> Void
    private var onFailure: (() -> Void)?
    private let queryItemNames: [String]
    private let request: URLRequest
    
    public init(
        request: URLRequest,
        queryItemNames: [String],
        onComplete: @escaping ([String: String]) -> Void,
        onFailure: (() -> Void)? = nil
    ) {
        self.request = request
        self.queryItemNames = queryItemNames
        self.onComplete = onComplete
        self.onFailure = onFailure
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupWebView()
        loadWebView()
    }
    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .ic24Close,
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
    }
    
    private func setupWebView() {
        webView.snp.makeConstraints { $0.edges.equalToSuperview() }
        setupLoadingState()
    }
    
    private func loadWebView() {
        webView.load(request)
    }
    
    private func setupLoadingState() {
        // TODO: Использовать после выноса BOKStateOverlayView в пакет
//        view.addSubview(overlay)
//        overlay.snp.makeConstraints { $0.edges.equalToSuperview() }
//        overlay.setState(.invisible, animated: false)
//        overlay.setLoadingSubtitle("EsiaWebAuthorization.Overlay.Subtitle".localized)
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             changeHandler: { [weak self] webView, _ in
//                 let state: BOKStateOverlayViewState = webView.estimatedProgress == 0.1 ? .loading : .invisible
//                 self?.overlay.setState(state, animated: false)
             })
    }
    
    @objc private func goBack() {
        dismiss(animated: true)
    }
}

extension EsiaWebAuthorizationVC: WKNavigationDelegate {
    
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        guard let onFailure = onFailure else {
            decisionHandler(.allow)
            return
        }
        if let response = navigationResponse.response as? HTTPURLResponse,
           response.statusCode >= 500 {
            // TODO: Использовать после выноса BOKStateOverlayView в пакет
//            overlay.setState(.invisible, animated: false)
            decisionHandler(.cancel)
            dismiss(animated: true, completion: {
                onFailure()
            })
        } else {
            decisionHandler(.allow)
        }
    }
    
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let urlString = navigationAction.request.url?.absoluteString,
           let params = URLComponents(string: urlString)?.queryItems,
           queryItemNames.count >= 1 {
            let result = checkNames(params)
            if result.count == queryItemNames.count {
                // TODO: Использовать после выноса BOKStateOverlayView в пакет
//                overlay.setState(.invisible, animated: false)
                dismiss(animated: true, completion: {
                    self.onComplete(result)
                })
            }
        }
        decisionHandler(.allow)
    }
    
    private func checkNames(_ params: [URLQueryItem]) -> [String: String] {
        var result = [String: String]()
        for queryItemName in queryItemNames {
            if let paramToFind = params.first(where: { $0.name == queryItemName }),
               let value = paramToFind.value {
                result[queryItemName] = value
            }
        }
        return result
    }
}
