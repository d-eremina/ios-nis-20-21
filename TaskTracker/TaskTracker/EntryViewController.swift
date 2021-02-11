//
//  EntryViewController.swift
//  TaskTracker
//
//  Created by Daria Eremina on 10.02.2021.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var heading: UITextField!
    @IBOutlet var annotation: UITextField! 
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heading.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    
    @objc func saveTask() {
        guard let heading = heading.text, !heading.isEmpty else {
            return
        }
        
        guard let annotation = annotation.text, !annotation.isEmpty else {
            return
        }
        
        guard let lastId = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        Task.last_id = lastId + 1
        UserDefaults().set(Task.last_id, forKey: "count")
        
        let newTask = Task(id: Task.last_id, heading: heading, annotation: annotation)
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: newTask, requiringSecureCoding: false)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: "task_\(newTask.id)")
        } catch {
            print("ERROR")
        }
        
        update?()
        navigationController?.popViewController(animated: true)
    }
    
}
