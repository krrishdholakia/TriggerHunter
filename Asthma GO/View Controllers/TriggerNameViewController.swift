//
//  TriggerNameViewController.swift
//  Trigger Hunter AR
//
//  Created by Cal Stephens on 11/9/17.
//  Copyright © 2017 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import UIKit

class TriggerNameViewController: UIViewController {
    
    var trigger: Trigger!
    
    @IBOutlet weak var textLabel: UILabel!
    
    
    // MARK: Setup
    
    static func create(for trigger: Trigger) -> TriggerNameViewController {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "Trigger Name") as! TriggerNameViewController
        viewController.trigger = trigger
        return viewController
    }
    
    override func viewDidLoad() {
        textLabel.text = trigger.name
    }
    
}
