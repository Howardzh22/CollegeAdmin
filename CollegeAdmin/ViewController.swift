//
//  ViewController.swift
//  CollegeAdmin
//
//  Created by 周浩 on 11/20/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var actInput: UITextField!
    
    @IBOutlet weak var pwdInput: UITextField!
    
    @IBOutlet weak var TopLabel: UILabel!
    
    @IBAction func OnButtonClicked(_ sender: UIButton) {
        let expectedEmail = "1"
        let expectedPassword = "2"
        
        if let enteredEmail = actInput?.text, let enteredPassword = pwdInput?.text {
            if enteredEmail == expectedEmail && enteredPassword == expectedPassword
            {
               performSegue(withIdentifier: "LoginSuccess", sender: self)
            }
            else
            {
                displayMessage("Login Failed", "Please check your email and password")
            }
        }
    }
    
    func displayMessage(_ title:String, _ msg:String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

