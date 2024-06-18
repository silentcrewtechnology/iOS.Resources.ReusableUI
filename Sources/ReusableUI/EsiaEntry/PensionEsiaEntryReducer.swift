//
//  PensionEsiaEntryReducer.swift
//  ABOL
//
//  Created by Ilnur Mugaev on 07.09.2022.
//  Copyright © 2022 ps. All rights reserved.
//

import Foundation

package final class PensionEsiaEntryReducer: ReducerRules {
    
    typealias ViewState = PensionEsiaEntryViewState
    typealias ViewMutation = PensionEsiaEntryMutation
    
    func getNewViewState(
        oldViewState: ViewState,
        viewMutations: [ViewMutation]
    ) -> ViewState {
        var newState = oldViewState
        for mutation in viewMutations {
            switch mutation {
            case .showErrorAlert:
                newState.errorAlertVisible = true
            case .hideErrorAlert:
                newState.errorAlertVisible = false
            }
        }
        return newState
    }
}
