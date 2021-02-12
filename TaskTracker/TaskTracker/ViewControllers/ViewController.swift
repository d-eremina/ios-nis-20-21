//
//  ViewController.swift
//  TaskTracker
//
//  Created by Daria Eremina on 10.02.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var tasks = [Task]()
    // var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        updateTasks()
    }
    
    func updateTasks() {
        tasks.removeAll()
        
        guard let id = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        Task.last_id = id
        
        for x in 0...Task.last_id {
            do {
                print("check task_\(x)")
                if let decoded  = UserDefaults.standard.object(forKey: "task_\(x)") as? Data {
                    let decodedTeams = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! Task
                    tasks.append(decodedTeams)
                }
            } catch {
                
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd() {
        let viewController = storyboard?.instantiateViewController(identifier: "Entry") as! EntryViewController
        viewController.title = "New Task"
        viewController.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(viewController, animated: true)
        _ = viewController.view
        viewController.saveNewTask()
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let currentTask = self.tasks[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            let viewController = self.storyboard?.instantiateViewController(identifier: "Entry") as! EntryViewController
            viewController.title = "Edit Task"
            viewController.update = {
                DispatchQueue.main.async {
                    self.updateTasks()
                }
            }
            self.navigationController?.pushViewController(viewController, animated: true)
            _ = viewController.view
            
            viewController.editTask(currentTask: currentTask)
            completion(true)
        }
        action.image = UIImage(contentsOfFile: "edit")
        action.backgroundColor = UIColor(red: 0.95, green: 0.76, blue: 0.2, alpha: 1)
        return action
    }
    
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        let currentTask = tasks[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completion) in
            print("complete" + currentTask.heading)
            
            // TODO:
            
            
            completion(true)
        }
        action.image = UIImage(contentsOfFile: "edit")
        action.backgroundColor = UIColor(red: 0, green: 0.83, blue: 0.04, alpha: 1)
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            
            self.tableView.beginUpdates()
            
            let currentTask = self.tasks[indexPath.row]
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.tableView.endUpdates()
            UserDefaults().setValue(nil, forKey: "task_\(currentTask.id)")
            print("delete task_\(currentTask.id)")
            // self.update?()
            completion(true)
        }
        action.backgroundColor = .red
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
        viewController.title = "New Task"
        viewController.task = tasks[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].heading
        cell.detailTextLabel?.text = tasks[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [complete])
    }
}
