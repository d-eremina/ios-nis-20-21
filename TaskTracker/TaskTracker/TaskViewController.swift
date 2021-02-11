//
//  TaskViewController.swift
//  TaskTracker
//
//  Created by Daria Eremina on 10.02.2021.
//

import UIKit

class TaskViewController: UIViewController {
    @IBOutlet var label: UILabel!
    
    var task: String?
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask(){
        /*guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        let newCount = count - 1
        UserDefaults().set(newCount, forKey: "count")*/
        //UserDefaults().setValue(nil, forKey: "task_\(currentPosition)")
       // update?()
        //navigationController?.popViewController(animated: true)
    }

}
