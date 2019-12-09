//
//  DrugsTableViewController.swift
//  DrugBook
//
//  Created by Maksim Pisaryk on 12/8/19.
//  Copyright © 2019 cecs. All rights reserved.
//

import UIKit
import CoreData

class DrugsTableViewController: UITableViewController {
    
    var drugs: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadDataFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drugs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrugsCell", for: indexPath)

        // Configure the cell...
        let drug = drugs[indexPath.row] as? Drug
        cell.textLabel?.text = drug?.drugName
        cell.detailTextLabel?.text = drug?.drugType
        cell.accessoryType = .detailDisclosureButton

        return cell
    }
    
    func loadDataFromDatabase() {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Drug")
        
        do {
            drugs = try context.fetch(request)
        } catch let error as NSError {
            print("could not fetch. \(error), \(error.userInfo)")
        }
        
    }

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
            
            let drug = drugs[indexPath.row] as? Drug
            let context = appDelegate.persistentContainer.viewContext
            context.delete(drug!)
            do {
                try context.save()
            }
            catch {
                fatalError("Error saving context: \(error)")
            }
            loadDataFromDatabase()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisDrug = drugs[indexPath.row] as? Drug
        let name = thisDrug!.drugName!
        let actionHandler = { (action:UIAlertAction!) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DrugsController")
                as? DrugsViewController
            controller?.selectedDrug = thisDrug
            self.navigationController?.pushViewController(controller!, animated: true)
        }
        
        let alertController = UIAlertController(title: "Drug selected",
                                                message:  "Selected row: \(indexPath.row) (\(name))",
            preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        let actionDetails = UIAlertAction(title: "Show Details",
                                          style: .default,
                                          handler: actionHandler)
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated: true, completion: nil)
    }
 */

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
        
        if segue.identifier == "EditDrug" {
            let drugController = segue.destination as? DrugsViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let thisDrug = drugs[selectedRow!] as? Drug
            drugController?.selectedDrug = thisDrug!
        }
     }

}
