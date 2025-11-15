//
//  PensionEsiaEntryPresenter.swift
//  ABOL
//
//  Created by Ilnur Mugaev on 07.09.2022.
//  Copyright © 2022 ps. All rights reserved.
//

import Foundation
import UIKit

public final class PensionEsiaEntryPresenter: PresenterRules {
    
    typealias ViewController = PensionEsiaEntryVC
    typealias ViewState = PensionEsiaEntryViewState
    typealias Action = PensionEsiaEntryAction
    typealias ViewMutation = PensionEsiaEntryMutation
    typealias Reducer = PensionEsiaEntryReducer
    
    public enum EntryType {
        case pension
        case passport
        
        var purpose: Int? {
            switch self {
            case .pension: return nil
            case .passport: return 1
            }
        }
        
        var subtitle: String {
            switch self {
            case .pension: return "Введите логин и пароль от портала Госуслуги, чтобы заполнить заявление на\u{00A0}получение пенсии в\u{00A0}Ак\u{00A0}Барс\u{00A0}Банке"
            case .passport: return "Введите логин и пароль от портала Госуслуги, чтобы актуализировать паспортные данные"
            }
        }
    }
    
    private enum Constants {
        static let queryItemClientId = "digitalProfileClientId"
        static let queryItemUserId = "digitalProfileUserId"
    }
    
    weak var viewController: ViewController?
    private(set) lazy var viewState: ViewState = .init()
    private(set) lazy var reducer: Reducer = .init()
    
    private let request: URLRequest
    private let entryType: EntryType
    
    public init(
        request: URLRequest,
        entryType: EntryType
    ) {
        self.request = request
        self.entryType = entryType
    }
    
    // MARK: - Rules
    
    func handle(_ action: Action) {
        switch action {
        case .viewDidLoad:
            viewDidLoad()
        case .closeButtonTapped:
            closeButtonTapped()
        case .esiaEntryButtonTapped:
            esiaEntryButtonTapped()
        case let .errorOptionTapped(option):
            errorOptionTapped(option: option)
        }
    }
    
    func apply(_ viewMutations: [ViewMutation]) {
        guard !viewMutations.isEmpty else { return }
        viewState = reducer.getNewViewState(oldViewState: viewState, viewMutations: viewMutations)
        viewController?.setViewState(viewState)
    }
    
    // MARK: Actions
    
    private func viewDidLoad() {
        switch entryType {
        case .pension: break // PensionMetrica.log(.esiaEntryOpened)
        case .passport: break // PassportMetrica.log(.esiaEntryOpened)
        }
    }
    
    private func closeButtonTapped() {
        switch entryType {
        case .pension: break // PensionMetrica.log(.esiaEntryClosed)
        case .passport: break //PassportMetrica.log(.esiaEntryClosed)
        }
        viewController?.dismiss(animated: true)
    }
    
    private func esiaEntryButtonTapped() {
        switch entryType {
        case .pension: break // PensionMetrica.log(.esiaWebAuthorizationOpened)
        case .passport: break // PassportMetrica.log(.esiaWebAuthorizationOpened)
        }
        let esiaVC = EsiaWebAuthorizationVC(
            request: request,
            queryItemNames: [
                Constants.queryItemClientId,
                Constants.queryItemUserId
            ],
            onComplete: { [weak self] items in
                guard
                    let self = self,
                    let sessionId = items[Constants.queryItemClientId],
                    let userId = items[Constants.queryItemUserId]
                else { return }
                switch self.entryType {
                case .pension: break // PensionMetrica.log(.esiaWebAuthorizationSucceeded)
                case .passport: break // PassportMetrica.log(.esiaWebAuthorizationSucceeded)
                }
                self.onComplete(sessionId: sessionId, userId: userId)
            },
            onFailure: { [weak self] in
                guard let self = self else { return }
                switch self.entryType {
                case .pension: break // PensionMetrica.log(.esiaWebAuthorizationFailed)
                case .passport: break // PassportMetrica.log(.esiaWebAuthorizationFailed)
                }
                self.apply([.showErrorAlert])
            })
        
        let containerVC = UINavigationController(rootViewController: esiaVC)
        containerVC.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.present(containerVC, animated: true)
    }
    
    private func onComplete(sessionId: String, userId: String) {
        viewController?.idsReceived?(sessionId, userId)
        viewController?.dismiss(animated: false)
    }
    
    private func errorOptionTapped(option: PensionEsiaEntryAction.Option) {
        apply([.hideErrorAlert])
        switch option {
        case .retry:
            handle(.esiaEntryButtonTapped)
        case .ok:
            handle(.closeButtonTapped)
        }
    }
}
