//
//  InterfaceController.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 02.01.2022.
//

import WatchKit


class InterfaceController: WKInterfaceController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var table: WKInterfaceTable!
    
    // MARK: - Lifecycle
    
    override func willActivate() {
        guard monuments == nil else { return }
        let locationManager = LocationManager()
        
        NetworkManager.shared.requestMonuments(location: locationManager.currentLocation.coordinate) { [weak self] responseResult in
            switch responseResult {
            case .success(let monuments):
                self?.monuments = monuments
                self?.setupTable(monuments)
                
            case .failure(let error):
                print("[dev] error: \(error)")
            }
        }
    }
    
    // MARK: - Private
    
    private var monuments: [Monument]?
    
}

// MARK: - User interactions

extension InterfaceController {
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        super.table(table, didSelectRowAt: rowIndex)
        guard let monuments = monuments else { return }
        
        let monument = monuments[rowIndex]
        let monumentId = monument.id
        let monumentTitle = monument.name
        let monumentContext = MonumentController.MonumentContext(id: monumentId, title: monumentTitle)
        
        pushController(withName: "MonumentController", context: monumentContext)
    }
    
}

// MARK: - Setup

private extension InterfaceController {
    
    func setupTable(_ monuments: [Monument]) {
        table.setNumberOfRows(monuments.count, withRowType: "MyRow")
        
        for (index, monument) in monuments.enumerated() {
            if let controller = table.rowController(at: index) as? MainTable {
                controller.set(text: monument.name)
                controller.set(image: .placeholder)
                
                ImageLoader.shared.loadImages(from: [monument.majorPhotoImageUrl]) { images in
                    controller.set(image: images.first)
                }
            }
        }
    }
    
}
