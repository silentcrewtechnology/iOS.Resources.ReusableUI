//
//  DocumentModel.swift
// 
//
//  Created by Ilnur Mugaev on 25.04.2024.
//

import Foundation
import QuickLook

public class DocumentModel: NSObject, QLPreviewItem {
    
    public var previewItemURL: URL?
    public var previewItemTitle: String?
    
    public init(
        itemURL: URL? = nil,
        itemTitle: String? = nil
    ) {
        self.previewItemURL = itemURL
        self.previewItemTitle = itemTitle
    }
}
