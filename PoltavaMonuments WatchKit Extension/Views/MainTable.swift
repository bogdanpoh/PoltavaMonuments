//
//  MainTable.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 02.01.2022.
//

import WatchKit

class MainTable: NSObject {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var rowImage: WKInterfaceImage!
    @IBOutlet private weak var rowLabel: WKInterfaceLabel!
    @IBOutlet private weak var badgeButton: WKInterfaceButton!
    
}

// MARK: - Set

extension MainTable {
    
    func set(image: UIImage?) {
        rowImage.setImage(image)
    }
    
    func set(text: String) {
        rowLabel.setText(text)
    }
    
    func setBadge(text: String?) {
        badgeButton.setHidden(false)
        badgeButton.setTitle(text)
    }
    
}
