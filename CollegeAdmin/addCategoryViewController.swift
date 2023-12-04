//
//  addCategoryViewController.swift
//  CollegeAdmin
//
//  Created by 周浩 on 11/29/23.
//

import UIKit
import CoreData

class addCategoryViewController: UIViewController {
    
    var managedContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
    var categoryModel = [Categories]()

    @IBOutlet weak var name: UITextField!
    
    @IBAction func add(_ sender: UIButton) {
        let n = name.text
        if n == ""
        {
            displayMessage("error", "name can't be empty!")
        }
        else
        {
            loadSavedData()
            let newCategory = Categories(context: self.managedContext)
            newCategory.name = n
            newCategory.id = Int32((categoryModel.last?.id ?? 0)+1)
            categoryModel.append(newCategory)
            do{
                try managedContext.save()
                displayMessage("congratulations", "add successfully!")
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
        let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
        let sortDescriotor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriotor]
        do
        {
            categoryModel = try (managedContext.fetch(fetchRequest)) as [Categories]
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
