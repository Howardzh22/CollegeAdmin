//
//  collegeTableViewController.swift
//  CollegeAdmin
//
//  Created by 周浩 on 11/21/23.
//

import UIKit
import CoreData

class collegeTableViewController: UITableViewController{
    
    
    
    var managedContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    let fetchRequest: NSFetchRequest<Colleges> = Colleges.fetchRequest()
    var collegeModel = [Colleges]()


    
    
    
    //let searchController = UISearchController(searchResultsController: nil)


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
//        searchController.searchBar.delegate = self
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "enter your search"
//        navigationItem.searchController = searchController
//        
        self.definesPresentationContext = true
        
        loadSavedData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if(isFiltering())
//        {
//            return filter.count
//        }
//        else
//        {
//            return college.count
//        }
        
        return collegeModel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

//        
//        if(isFiltering())
//        {
//            object = filter[indexPath.row]
//        }
//        else
//        {
//            object = college[indexPath.row]
//        }
        
        var object = collegeModel[indexPath.row]
        cell.textLabel?.text = String(object.id)
        cell.detailTextLabel?.text = "name:"+object.name!
        //cell.imageView?.image = UIImage(named: "p\(indexPath.row).jpeg")
        if object.imageData == nil
        {
            let image = UIImage(named: "p\(indexPath.row).jpeg")
        }
        else {let image = UIImage(data: object.imageData!)
        //if let image = UIImage(named: "p\(indexPath.row).jpeg") {
            cell.imageView?.image = image
        } 
//            else {
//            print("Image not found for p\(indexPath.row).jpeg")
//            cell.imageView?.image = nil
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let detail = CdTableViewController()
        self.navigationController?.show(detail, sender: self)
    }
    
    func loadSavedData()
    {
        let fetchRequest: NSFetchRequest<Colleges> = Colleges.fetchRequest()
        let sortDescriotor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriotor]
        do
        {
            self.collegeModel = try (self.managedContext.fetch(fetchRequest)) as [Colleges]
            tableView.reloadData()
            if self.collegeModel.isEmpty {
                        print("Core Data is empty.")
                    }
        }
        catch
        {
            fatalError("error to fetch")
        }
    }
    
//    func addCollege(newC: Colleges)
//    {
//        collegeModel.append(newC)
//        tableView.reloadData()
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let flag = deleteC(id: Int(collegeModel[indexPath.row].id))
            if flag
            {
                collegeModel.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func deleteC(id:Int) ->Bool
    {
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
                let dc = try managedContext.fetch(fetchRequest)

                // Assuming there's only one college with the specified name
                if let collegeToDelete = dc.first {
                    var flag = 0
//                    let c = try managedContext.fetch(fetchC)
//                    let p = try managedContext.fetch(fetchP)
//                    for course in c{
//                        if course.cid == collegeToDelete.id
//                        {
//                            flag = 1
//                            displayMessage("error", "college can't be delete!")
//                        }
//                    }
//                    for program in p{
//                        if program.cid == collegeToDelete.id
//                        {
//                            flag = 1
//                            displayMessage("error", "college can't be delete!")
//                        }
//                    }
//                    if flag == 0
//                    {
                        managedContext.delete(collegeToDelete)
//                    }

                    // Save the changes
                    do {
                        try managedContext.save()
                        displayMessage("congratulations!", "delete college successfully!")
                        return true
                    } catch {
                        displayMessage("error", "Error saving after deletion")
                    }
                } else {
                    displayMessage("error", "college doesn't exist")
                }
            } catch {
                displayMessage("error", "can't fetch")
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
    
    func refresh()
    {
        tableView.reloadData()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let row = self.tableView.indexPathForSelectedRow?.row
        if let vdc = (segue.destination as? CdTableViewController)
        {
            vdc.idT = String(collegeModel[row!].id)
            vdc.nameT = collegeModel[row ?? 0].name
            vdc.addressT = collegeModel[row ?? 0].address
            vdc.imageData = collegeModel[row ?? 0].imageData
        }

        
    }
    

}
