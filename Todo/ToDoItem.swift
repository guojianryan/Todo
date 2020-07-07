//
//  ToDoItem.swift
//  Todo
//
//  Created by Ryan Guo on 7/7/2020.
//  Copyright © 2020 Ryan Guo. All rights reserved.
//

import Foundation

class ToDoItem : NSObject, NSCoding{
    
    init(title : String, done : Bool) {
        self.title = title
        self.done = done
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.done, forKey: "done")
    }
    
    required init?(coder: NSCoder) {
        if let title = coder.decodeObject(forKey: "title") as? String {
            self.title = title
        }
        if let done = coder.decodeBool(forKey: "done") as? Bool{
            self.done = done
        }
    }
    
    var title : String = ""
    var done: Bool = false
}
