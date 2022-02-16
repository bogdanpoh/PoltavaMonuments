//
//  InterfaceController.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 02.01.2022.
//

import WatchKit


class InterfaceController: WKInterfaceController {

    // MARK: - UI
    
    @IBOutlet private weak var table: WKInterfaceTable!
    
    // MARK: - Lifecycle
    
    override func willActivate() {
        let locationManager = LocationManager()
        
        NetworkManager.shared.requestImageUrls(location: locationManager.currentLocation.coordinate) { [weak self] stringUrls in
            guard let stringUrls = stringUrls else { return }
            
            self?.setupTableView(with: stringUrls.map { UIImage(named: $0) ?? .init()}, placeholderMode: true)
            
            ImageLoader.shared.loadImages(from: stringUrls) { images in
                self?.setupTableView(with: images)
            }
        }
    }
    
    // MARK: - User interactions
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        super.table(table, didSelectRowAt: rowIndex)
        
        //detect of tap on row
    }
    
}

// MARK: - Setup

private extension InterfaceController {
    
    func setupTableView(with images: [UIImage], placeholderMode: Bool = false) {
        let locationManager = LocationManager()
        let lat = locationManager.currentLocation.coordinate.latitude
        let lon = locationManager.currentLocation.coordinate.longitude
        table.setNumberOfRows(images.count, withRowType: "MyRow")
        
        for (index, image) in images.enumerated() {
            if let controller = table.rowController(at: index) as? MainTable {
                controller.set(image: placeholderMode ? .placeholder : image)
                controller.set(text: "lat: \(lat) lon: \(lon)")
            }
        }
    }
    
}
