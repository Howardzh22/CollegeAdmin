//
//  LoginReplaceSegue.swift
//  CollegeAdmin
//
//  Created by 周浩 on 11/20/23.
//

import Foundation
import UIKit
class LoginReplaceSegue: UIStoryboardSegue{
    override func perform() {
            // Access the source and destination view controllers
            let sourceViewController = self.source
            let destinationViewController = self.destination
        //sourceViewController.show(destinationViewController, sender: sourceViewController)

        sourceViewController.present(destinationViewController, animated: true, completion: nil)
        
        }
}
