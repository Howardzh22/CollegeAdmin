//
//  addPViewController.swift
//  CollegeAdmin
//
//  Created by 周浩 on 11/29/23.
//

import UIKit
import CoreData

class addPViewController: UIViewController {
    
    var managedContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    let fetchRequest: NSFetchRequest<Programs> = Programs.fetchRequest()
    var programModel = [Programs]()
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var cid: UITextField!
    
    @IBAction func add(_ sender: UIButton) {
        let n = name.text, c = cid.text
        if n == "" || c == ""
        {
            displayMessage("error", "name or college_id can't be empty!")
        }
        
        else{
            loadSavedData()
            let newProgram = Programs(context: self.managedContext)
            newProgram.name = n
            newProgram.cid = Int32(c!)!
            newProgram.id = Int32((programModel.last?.id ?? 0)+1)
            programModel.append(newProgram)
            do{
                try managedContext.save()
                displayMessage("congratulations!", "add program successfully!")
            }catch{
                displayMessage("error", "data can't be saved")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func displayMessage(_ title:String, _ msg:String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadSavedData()
    {
        let fetchRequest: NSFetchRequest<Programs> = Programs.fetchRequest()
        let sortDescriotor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriotor]
        do
        {
            self.programModel = try (self.managedContext.fetch(fetchRequest)) as [Programs]
        }
        catch
        {
            fatalError("error to fetch")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
