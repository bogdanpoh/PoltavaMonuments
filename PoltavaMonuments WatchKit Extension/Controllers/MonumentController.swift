//
//  MonumentController.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 21.02.2022.
//

import WatchKit

class MonumentController: WKInterfaceController {
    
    struct MonumentContext {
        let id: Int
        let title: String
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var monumentTable: WKInterfaceTable!
    
    // MARK: - Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setTitle("Back")
        
        guard let monumentContext = context as? MonumentContext else { return }
        self.monumentContext = monumentContext
    }
    
    override func willActivate() {
        super.willActivate()
        guard let monumentContext = monumentContext else { return }
        setTitle(monumentContext.title)
        
        NetworkManager.shared.requestMonument(id: monumentContext.id) { [weak self] result in
            switch result {
            case .success(let monument):
                self?.setupTable(monument: monument)
            case .failure(let error):
                print("[dev] \(error)")
            }
        }
    }
    
    // MARK: - Private
    
    private var monumentContext: MonumentContext?
    
}

// MARK: - Setup

private extension MonumentController {
    
    func setupTable(monument: Monument) {
        let addictionCellCount = 2
        let monumentPhotos = monument.monumentPhotos
        var rowTypes = Array(repeating: "MonumentRow", count: monumentPhotos.count + 1)
        rowTypes.insert("ConditionRow", at: 0)
        monumentTable.setRowTypes(rowTypes)
        let cellCount = monumentPhotos.count + addictionCellCount
        
        for index in 0...cellCount {
            if index == 0 {
                if let controller = monumentTable.rowController(at: index) as? ConditionRow {
                    let conditionStatus = UserDefaults.standard.string(forKey: monument.condition.abbreviation)
                    
                    controller.set(backgroundColor: monument.condition.status.color)
                    controller.set(title: conditionStatus ?? monument.condition.abbreviation)
                }
            } else if index == 1 {
                if let controller = monumentTable.rowController(at: index) as? MonumentTable {
                    controller.set(title: monument.description)
                }
            } else if index > 1 {
                if let controller = monumentTable.rowController(at: index) as? MonumentTable {
                    let photoUrl = monumentPhotos[index - addictionCellCount].url
                    controller.set(image: .placeholder)
                    
                    ImageLoader.shared.loadImage(url: photoUrl) { [weak controller] image in
                        controller?.set(image: image)
                    }
                }
            }
        }
    }
    
}
