//
//  MainTable.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 02.01.2022.
//

import WatchKit

class MainTable: NSObject {
    
    // MARK: - UI
    
    @IBOutlet weak var rowImage: WKInterfaceImage!
    @IBOutlet weak var rowLabel: WKInterfaceLabel!
    
}

// MARK: - Set

extension MainTable {
    
    func set(image: UIImage?) {
        rowImage.setImage(image)
    }
    
    func set(text: String) {
        rowLabel.setText(text)
    }
    
}
