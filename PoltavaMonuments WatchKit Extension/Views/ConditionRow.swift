//
//  ConditionRow.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 22.02.2022.
//

import WatchKit

class ConditionRow: NSObject {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var statusGroup: WKInterfaceGroup!
    @IBOutlet private weak var statusLabel: WKInterfaceLabel!
    
}

// MARK: - Set

extension ConditionRow {
    
    func set(backgroundColor: UIColor?) {
        statusGroup.setBackgroundColor(backgroundColor)
    }
    
    func set(title: String?) {
        statusLabel.setText(title)
    }
    
}
