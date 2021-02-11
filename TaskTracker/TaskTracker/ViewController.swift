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
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks"
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let currentTask = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            
            UserDefaults().setValue(nil, forKey: "task_\(currentTask.id)")
            update?()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
