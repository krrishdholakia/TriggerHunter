//
//  DoctorSecondViewController.swift
//  Asthma GO
//
//  Created by Krrish Dholakia on 4/28/18.
//  Copyright © 2018 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import UIKit

class DoctorSecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.performSegue(withIdentifier: "doctorThirdIdentifier", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
