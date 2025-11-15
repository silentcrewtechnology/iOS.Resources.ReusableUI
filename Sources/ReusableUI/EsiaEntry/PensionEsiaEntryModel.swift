//
//  PensionEsiaEntryModel.swift
//  ABOL
//
//  Created by Ilnur Mugaev on 07.09.2022.
//  Copyright © 2022 ps. All rights reserved.
//

import Foundation

package enum PensionEsiaEntryAction {
    case viewDidLoad
    case closeButtonTapped
    case esiaEntryButtonTapped
    case errorOptionTapped(Option)
    package enum Option { case ok, retry }
}

package struct PensionEsiaEntryViewState {
    var errorAlertVisible: Bool = false
}

package enum PensionEsiaEntryMutation {
    case showErrorAlert
    case hideErrorAlert
}
