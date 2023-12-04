//
//  addCollegeViewController.swift
//  CollegeAdmin
//
//  Created by 周浩 on 11/21/23.
//

import UIKit
import CoreData

class addCollegeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var logo: UIImageView!
    
    var path : URL?
    
    //var tableViewController: collegeTableViewController?
    
    var managedContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    let fetchRequest: NSFetchRequest<Colleges> = Colleges.fetchRequest()
    var collegeModel = [Colleges]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImages(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage,
            let imageURL = info[.imageURL] as? URL{
            logo.image = selectedImage
            path = imageURL
            //print(path)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCollege(_ sender: UIButton) {
        
        let n = name.text, a = address.text
        if n == "" || a == ""
        {
            displayMessage("error", "name or address can't be empty")
        }
        else
        {
            loadSavedData()
            let newCollege = Colleges(context: self.managedContext)
            newCollege.name = n
            newCollege.address = a
            newCollege.id = Int32((collegeModel.last?.id ?? 0)+1)
            if let imageData = try? Data(contentsOf: path!) {
                newCollege.imageData = imageData
                    }
            print(collegeModel.count)
            self.collegeModel.append(newCollege)
            do{
                try managedContext.save()
                displayMessage("congratulations!", "add college successfully!")
            }catch{
                displayMessage("error", "data can't be saved")
            }
            
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
            let fetchRequest: NSFetchRequest<Colleges> = Colleges.fetchRequest()
            let sortDescriotor = NSSortDescriptor(key: "id", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriotor]
            do
            {
                self.collegeModel = try (self.managedContext.fetch(fetchRequest)) as [Colleges]
            }
            catch
            {
                fatalError("error to fetch")
            }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addC" {
            if let destinationVC = segue.destination as? collegeTableViewController{
                // Pass the new college to the destination view controller
                destinationVC.refresh()
            }
        }
    }
}
