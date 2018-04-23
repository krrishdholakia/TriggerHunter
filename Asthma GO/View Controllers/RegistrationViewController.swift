
//
//  RegistrationViewController.swift
//  Trigger Hunter AR
//
//  Created by Krrish Dholakia on 4/22/18.
//  Copyright © 2018 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    

    @IBOutlet weak var participantID: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let roles = ["male", "female"]
    var roleTxt: String = ""
    var dobTxt: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerView?.delegate = self
        pickerView?.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onIDEntered(_ sender: Any) {
        let text = sender as? String ?? ""
        
        Alamofire.request("https://trigger-hunter.herokuapp.com/api/participants/newUser").validate().responseData { response in
            
            
            guard let data = response.data else {
                /* handle error? */ return
            }
            
            let ids = (try? JSONDecoder().decode([Participant].self, from: data)) ?? []
            
            for id in ids {
                if id.participant_id == text {
                    self.participantID.text = "This ID has already been used"
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onDateChanged(_ sender: UIDatePicker) {
        print("print \(sender.date)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        dobTxt = dateFormatter.string(from: sender.date)
        
        print(dobTxt)
    }
    
    @IBAction func onDoneClicked(_ sender: Any) {
        let parameters: Parameters = [
            "participant_id": participantID.text ?? "",
            "sex": roleTxt ,
            "date_of_birth": dobTxt
        ]
        
        
        Alamofire.request("https://trigger-hunter.herokuapp.com/api/participants/newUser", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseString {
            response in
            print(response)
    }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roleTxt = roles[row]
    }
}
