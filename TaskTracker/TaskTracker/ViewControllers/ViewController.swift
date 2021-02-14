//
//  ViewController.swift
//  TaskTracker
//
//  Created by Daria Eremina on 10.02.2021.
//

import CoreData
import UIKit

class ViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController()
    
    var tasks: [NSManagedObject] = []
    var filteredTasks: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        initSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      updateTasks()
    }

    
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "New", "In Progress", "Done"]
        searchController.searchBar.delegate = self
    }
    
    func updateTasks() {
        tasks.removeAll()
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
          tasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All") {
        filteredTasks = tasks.filter {
            task in
            let scopeMatch = (scopeButton == "All" || (task as! Task).status!.lowercased().contains(scopeButton.lowercased()))
            if (searchController.searchBar.text != "") {
                let searchTextMatch = (task as! Task).heading?.lowercased().contains(searchText.lowercased())
                return scopeMatch && searchTextMatch!
            } else {
                return scopeMatch
            }
        }
        tableView.reloadData()
    }
    
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        var commit: NSManagedObject!
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completion) in
            if self.searchController.isActive {
                commit = self.filteredTasks[indexPath.row]
            } else {
                commit = self.tasks[indexPath.row]
            }
            
            let currentTask = commit as! Task
            
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(commit)
            
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            let entity = NSEntityDescription.entity(forEntityName: "Task",
                                                    in: managedContext)!
            let savedTask = NSManagedObject(entity: entity,
                                            insertInto: managedContext)
            savedTask.setValue(currentTask.heading, forKey: "heading")
            savedTask.setValue(currentTask.annotation, forKey: "annotation")
            savedTask.setValue(currentTask.date, forKey: "date")
            savedTask.setValue("Done", forKey: "status")
            do {
                try managedContext.save()
                self.updateTasks()
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
            
            
            completion(true)
        }
        action.image = UIImage(contentsOfFile: "edit")
        action.backgroundColor = UIColor(red: 0, green: 0.83, blue: 0.04, alpha: 1)
        return action
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = storyboard?.instantiateViewController(identifier: "Task") as! TaskViewController
        
        let currentTask: Task
        if searchController.isActive {
            currentTask = filteredTasks[indexPath.row] as! Task
        } else {
            currentTask = tasks[indexPath.row] as! Task
        }
        
        viewController.title = currentTask.heading
        _ = viewController.view
        viewController.label.text = currentTask.heading
        viewController.annotation.text = currentTask.annotation
        viewController.date.text = currentTask.date
        viewController.task = currentTask
        viewController.indexPath = indexPath
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredTasks.count
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let task: NSManagedObject!
        if searchController.isActive {
            task = filteredTasks[indexPath.row]
        } else {
            task = tasks[indexPath.row]
        }
        
        cell.heading.text = task.value(forKeyPath: "heading") as? String
        cell.date.text = task.value(forKeyPath: "date") as? String
        cell.status.text = task.value(forKeyPath: "status") as? String
        cell.status.textColor = UIColor.black
        if cell.status.text == "New" {
            cell.status.textColor = UIColor.white
            cell.statusBackground.backgroundColor = UIColor.red
        } else if cell.status.text == "In Progress" {
            cell.statusBackground.backgroundColor = UIColor.yellow
        } else if cell.status.text == "Done" {
            cell.statusBackground.backgroundColor = UIColor.green
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit: NSManagedObject!
            if searchController.isActive {
                commit = filteredTasks[indexPath.row]
            } else {
                commit = tasks[indexPath.row]
            }
            
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(commit)
            
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try managedContext.save()
                updateTasks()
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [complete])
    }
}
