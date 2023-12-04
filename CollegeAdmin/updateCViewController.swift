//
//  updateCViewController.swift
//  CollegeAdmin
//
//  Created by 周浩 on 11/22/23.
//

import UIKit
import CoreData

class updateCViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var uid:Int?
    var path:URL?
    
    var managedContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    let fetchRequest: NSFetchRequest<Colleges> = Colleges.fetchRequest()
    var collegeModel = [Colleges]()
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var logo: UIImageView!
    
    
    @IBAction func selectI(_ sender: UIButton) {
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
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func update(_ sender: UIButton) {
        let n = name.text, a = address.text
        if n == "" && a == "" && path == nil
        {
            displayMessage("error", "at least update 1 attribute!")
        }
        else
        {
            loadSavedData()
            if n != ""
            {
                collegeModel[uid!].name = n
            }
            if a != ""
            {
                collegeModel[uid!].address = a
            }
            if path != nil
            {
                if let imageData = try? Data(contentsOf: path!)
                {
                    collegeModel[uid!].imageData = imageData
                }
            }
            do{
                try managedContext.save()
                displayMessage("Congratulations", "update successfully!")
            }
            catch{
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
