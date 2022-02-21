//
//  MonumentTable.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 21.02.2022.
//

import WatchKit

class MonumentTable: NSObject {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var monumentImage: WKInterfaceImage!
    @IBOutlet private weak var monumentDescriptionLabel: WKInterfaceLabel!
    
}

// MARK: - Set

extension MonumentTable {
    
    func set(image: UIImage?) {
        monumentImage.setImage(image)
        monumentDescriptionLabel.setHidden(true)
    }
    
    func set(title: String?) {
        monumentDescriptionLabel.setText(title)
        monumentImage.setHidden(true)
    }
    
}

