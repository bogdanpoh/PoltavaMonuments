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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        checkCondition()
    }
    
    override func willActivate() {
        super.willActivate()
        
        guard monuments == nil else { return }
        let locationManager = LocationManager()
        
        NetworkManager.shared.requestMonuments(coordinate: locationManager.currentLocation.coordinate) { [weak self] responseResult in
            switch responseResult {
            case .success(let monuments):
                let filteredMonuments = monuments.filter({ !$0.tags.contains("easter_egg") })
                self?.monuments = filteredMonuments
                self?.setupTable(filteredMonuments)
                
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
                
                if monument.condition.status == .lost {
                    let badgeTitle = UserDefaults.standard.string(forKey: monument.condition.abbreviation) ?? monument.condition.abbreviation
                    controller.setBadge(text: badgeTitle)
                }
                
                ImageLoader.shared.loadImage(url: monument.majorPhotoImageUrl) { [weak controller] image in
                    controller?.set(image: image)
                }
            }
        }
    }
    
}

// MARK: - Check save condition

private extension InterfaceController {
    
    func checkCondition() {
        guard !UserDefaults.standard.bool(forKey: "isCondition") else { return }
        
        NetworkManager.shared.requestCondition { result in
            switch result {
            case .success(let conditions):
                UserDefaults.standard.set(true, forKey: "isCondition")
                conditions.forEach { UserDefaults.standard.set($0.name ?? $0.abbreviation, forKey: $0.abbreviation) }
                
            case .failure(let error):
                print("[dev] error request condition: \(error)")
            }
        }
    }
    
}
