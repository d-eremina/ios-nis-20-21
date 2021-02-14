//
//  TaskViewController.swift
//  TaskTracker
//
//  Created by Daria Eremina on 10.02.2021.
//

import CoreData
import UIKit

class TaskViewController: UIViewController {
    @IBOutlet var label: UILabel!
    @IBOutlet var annotation: UITextView!
    @IBOutlet var date: UILabel!
    
    var task: NSManagedObject?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editTask() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let viewController = storyboard?.instantiateViewController(identifier: "Entry") as! EntryViewController
        _ = viewController.view
        let currentTask = task as! Task
        viewController.title = currentTask.heading
        viewController.heading.text = currentTask.heading
        viewController.annotation.text = currentTask.annotation
        navigationController?.pushViewController(viewController, animated: true)
        
        managedContext.delete(task!)
        let vc = storyboard?.instantiateViewController(identifier: "Main") as! ViewController
        _ = vc.view
        vc.tableView.deleteRows(at: [indexPath!], with: .fade)
        do {
            try managedContext.save()
            vc.updateTasks()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
