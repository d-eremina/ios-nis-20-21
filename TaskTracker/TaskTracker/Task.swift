//
//  Task.swift
//  TaskTracker
//
//  Created by Daria Eremina on 11.02.2021.
//

import Foundation

class Task: NSObject, NSCoding {
    var heading = ""
    var annotation = ""
    var id = 0
    static var last_id = 0
    
    init(id: Int, heading: String, annotation: String) {
        self.id = id
        self.heading = heading
        self.annotation = annotation
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? Int ?? aDecoder.decodeInteger(forKey: "id")
        heading = aDecoder.decodeObject(forKey: "heading") as! String
        annotation = aDecoder.decodeObject(forKey: "annotation") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(heading, forKey: "heading")
        aCoder.encode(annotation, forKey: "annotation")
    }
}
