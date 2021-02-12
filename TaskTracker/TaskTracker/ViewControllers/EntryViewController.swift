//
//  EntryViewController.swift
//  TaskTracker
//
//  Created by Daria Eremina on 10.02.2021.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var heading: UITextField!
    @IBOutlet var annotation: UITextView!
    @IBOutlet var date: UIDatePicker!
    static var task: Task = Task(id: -1, heading: "", annotation: "", date: "")
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heading.delegate = self
        date.preferredDatePickerStyle = .compact
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    
    func saveNewTask() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    func editTask(currentTask: Task) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveEdition))
        heading.insertText(currentTask.heading)
        annotation.insertText(currentTask.annotation)
        EntryViewController.task = currentTask
    }
    
    @objc func saveEdition() {
        guard let heading = heading.text, !heading.isEmpty else {
            return
        }
        
        guard let annotation = annotation.text, !annotation.isEmpty else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let taskDate = dateFormatter.string(from: date.date)
        
        let newTask = Task(id: EntryViewController.task.id, heading: heading, annotation: annotation, date: taskDate)
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let taskDate = dateFormatter.string(from: date.date)
        
        Task.last_id = lastId + 1
        UserDefaults().set(Task.last_id, forKey: "count")
        
        let newTask = Task(id: Task.last_id, heading: heading, annotation: annotation, date: taskDate)
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
