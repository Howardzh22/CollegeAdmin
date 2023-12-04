//
//  addCourseViewController.swift
//  CollegeAdmin
//
//  Created by 周浩 on 11/29/23.
//

import UIKit
import CoreData

class addCourseViewController: UIViewController {
    
    var managedContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    let fetchRequest: NSFetchRequest<Courses> = Courses.fetchRequest()
    var courseModel = [Courses]()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var cid: UITextField!
    @IBOutlet weak var pid: UITextField!
    @IBOutlet weak var ccid: UITextField!
    
    @IBAction func add(_ sender: UIButton) {
        let n = name.text, c = cid.text, p = pid.text, cc = ccid.text
        if n == "" || c == "" || p == "" || cc == ""
        {
            displayMessage("error", "input can't be empty!")
        }
        else
        {
            loadSavedData()
            let newCourse = Courses(context: managedContext)
            newCourse.id = Int32((courseModel.last?.id ?? 0)+1)
            newCourse.name = n
            newCourse.cid = Int32(c!)!
            newCourse.pid = Int32(p!)!
            newCourse.ccid = Int32(cc!)!
            courseModel.append(newCourse)
            do{
                try managedContext.save()
                displayMessage("congratulations", "add course successfully!")
            }catch{
                displayMessage("error", "can't fetch courses!")
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
        let fetchRequest: NSFetchRequest<Courses> = Courses.fetchRequest()
        let sortDescriotor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriotor]
        do
        {
            courseModel = try (managedContext.fetch(fetchRequest)) as [Courses]
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
