//
//  TaskViewController.swift
//  TaskTracker
//
//  Created by Daria Eremina on 10.02.2021.
//

import UIKit

class TaskViewController: UIViewController {
    @IBOutlet var label: UILabel!
    @IBOutlet var annotation: UILabel!
    
    var task: Task?
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = task?.heading
        annotation.text = task?.annotation
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask(){
        // UserDefaults().setValue(nil, forKey: "task_\(task?.id ?? -1)")
        update?()
        navigationController?.popViewController(animated: true)
    }
    
}
