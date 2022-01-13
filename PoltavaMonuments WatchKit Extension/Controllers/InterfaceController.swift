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
        NetworkManager.shared.requestImageUrls() { [weak self] stringUrls in
            guard let stringUrls = stringUrls else { return }
            
            ImageLoader.shared.loadImages(from: stringUrls) { images in
                self?.setupTableView(with: images)
            }
        }
    }

}

// MARK: - Setup

private extension InterfaceController {
    
    func setupTableView(with images: [UIImage]) {
        table.setNumberOfRows(images.count, withRowType: "MyRow")
        
        for (index, image) in images.enumerated() {
            if let controller = table.rowController(at: index) as? MainTable {
                controller.set(image: image)
            }
        }
    }
    
}
