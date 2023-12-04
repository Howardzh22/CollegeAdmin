//
//  categoryTableViewController.swift
//  CollegeAdmin
//
//  Created by 周浩 on 11/29/23.
//

import UIKit
import CoreData

class categoryTableViewController: UITableViewController {
    
    var managedContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
    let fetchC: NSFetchRequest<Courses> = Courses.fetchRequest()
    var categoryModel = [Categories]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadSavedData()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryModel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)

        // Configure the cell...
        var object = categoryModel[indexPath.row]
        cell.textLabel?.text = String(object.id)
        cell.detailTextLabel?.text = "name:"+object.name!

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let flag = deleteC(id: Int(categoryModel[indexPath.row].id))
            if flag
            {
                categoryModel.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func deleteC(id:Int) ->Bool
    {
        fetchRequest.predicate = NSPredicate(format:  "id == %d", id)
        do {
                let cats = try managedContext.fetch(fetchRequest)

                if let catToDelete = cats.first {
                    var flag = 0
                    do
                    {
                        let courses = try managedContext.fetch(fetchC)
                        for c in courses
                        {
                            if c.ccid == catToDelete.id
                            {
                                flag = 1
                                displayMessage("error", "can't delete course category!")
                                return false
                            }
                        }
                        if flag == 0
                        {
                            managedContext.delete(catToDelete)
                        }
                    } catch{
                        displayMessage("error", "can't fetch courses!")
                    }

                    // Save the changes
                    do {
                        try managedContext.save()
                        displayMessage("congratulations", "delete successfully!")
                        return true
                    } catch {
                        displayMessage("error", "Error saving after deletion")
                    }
                } else {
                    displayMessage("error", "course category doesn't exist!")
                }
            } catch {
                displayMessage("error", "can't fetch!")
            }
        return false
    }
    
    func displayMessage(_ title:String, _ msg:String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let row = self.tableView.indexPathForSelectedRow?.row
        if let vdc = (segue.destination as? CadTableViewController)
        {
            vdc.idT = String(categoryModel[row!].id)
            vdc.nameT = categoryModel[row ?? 0].name
        }

        
    }

}
