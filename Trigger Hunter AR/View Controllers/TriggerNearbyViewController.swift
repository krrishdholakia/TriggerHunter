//
//  TriggerNearbyViewController.swift
//  Trigger Hunter AR
//
//  Created by Cal Stephens on 12/3/17.
//  Copyright © 2017 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import UIKit

class TriggerNearbyViewController: UIViewController {
    
    var trigger: Trigger?
    @IBOutlet weak var triggerNearbyLabel: UILabel!
    
    // MARK: Setup
    
    static func create(for trigger: Trigger?) -> TriggerNearbyViewController {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "Trigger Nearby") as! TriggerNearbyViewController
        viewController.trigger = trigger
        return viewController
    }
    
    override func viewDidLoad() {
        if let trigger = trigger {
            triggerNearbyLabel.text = "There's \(trigger.subjectName) somewhere nearby..."
        } else {
            triggerNearbyLabel.text = "No trigger nearby"
        }
    }
    
}
