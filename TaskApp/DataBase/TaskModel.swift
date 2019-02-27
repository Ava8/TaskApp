//
//  DBModel.swift
//  TaskApp
//
//  Created by MacBook Air on 25.01.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class TaskModel: Object {
    @objc dynamic var title = ""
    @objc dynamic var isCompleted = false
    @objc dynamic var cathegory = 0
    @objc dynamic var id = 0
    
    convenience init(_ title: String, _ cathegory: Int) {
        self.init()
        self.title = title
        self.cathegory = cathegory
    }
    
    convenience init(json: JSON, cathegory: Int) {
        self.init()
        
        title = json["text"].stringValue
        isCompleted = json["isCompleted"].boolValue
        id = json["id"].intValue
        self.cathegory = cathegory
    }
    
}
