//
//  TaskViewController.swift
//  TaskTracker
//
//  Created by Daria Eremina on 10.02.2021.
//

import UIKit

class TaskViewController: UIViewController {
    @IBOutlet var label: UILabel!
    @IBOutlet var annotation: UITextView!
    
    var task: Task?
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = task?.heading
        annotation.text = task?.annotation
    }
}
