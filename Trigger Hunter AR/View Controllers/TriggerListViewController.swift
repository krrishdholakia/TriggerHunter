//
//  TriggerListViewController.swift
//  Trigger Hunter AR
//
//  Created by Cal Stephens on 11/9/17.
//  Copyright © 2017 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import UIKit

class TriggerListViewController: UITableViewController {
    
    enum TriggerListTableViewSection: Int {
        case note = 0
        case triggers = 1
        
        static let all = [TriggerListTableViewSection.note, .triggers]
        
        var numberOfRows: Int {
            switch self {
            case .note: return 1
            case .triggers: return Trigger.all.count
            }
        }
        
        func decorateCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            switch self {
            case .note:
                cell.textLabel?.text = "This screen is temporary, and will be replaced with Push Notifications once our server is ready."
                cell.textLabel?.font = .systemFont(ofSize: 17)
                cell.textLabel?.numberOfLines = 0
            case .triggers:
                let trigger = Trigger.all[indexPath.row]
                cell.textLabel?.text = trigger.name
                cell.imageView?.image = trigger.collectionViewImage
            }
        }
    }
    
    // MARK: Table View Data Source methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TriggerListTableViewSection.all.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TriggerListTableViewSection(rawValue: section)?.numberOfRows ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        TriggerListTableViewSection(rawValue: indexPath.section)?.decorateCell(cell, forRowAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: User Interaction
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == TriggerListTableViewSection.triggers.rawValue else {
            return
        }

        let arController = ARViewController.create(for: Trigger.all[indexPath.row])
        self.present(arController, animated: false, completion: nil)
    }
    
}

// MARK: Trigger+PaddedImage

extension Trigger {
    
    var collectionViewImage: UIImage {
        
        // plucked from https://stackoverflow.com/questions/2788028/how-do-i-make-uitableviewcells-imageview-a-fixed-size-even-when-the-image-is-sm with a few changes
        
        let padding: CGFloat = 15
        let itemSize = CGSize(width: 100, height: 100)
        let itemSizeWithPadding = CGSize(width: itemSize.width + padding*2, height: itemSize.height + padding*2)
        UIGraphicsBeginImageContextWithOptions(itemSizeWithPadding, false, UIScreen.main.scale)
        
        let imageRect: CGRect
        if(image.size.height > image.size.width) {
            let width = itemSize.height * image.size.width / image.size.height;
            imageRect = CGRect(x: padding + (itemSize.width - width) / 2, y: padding, width: width, height:itemSize.height)
        } else {
            let height = itemSize.width * image.size.height / image.size.width;
            imageRect = CGRect(x: padding, y: padding + (itemSize.height - height) / 2, width: itemSize.width, height: height)
        }
        
        image.draw(in: imageRect)
        let squareImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return squareImage!
    }
    
}
