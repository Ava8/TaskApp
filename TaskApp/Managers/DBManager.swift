//
//  DBManager.swift
//  TaskApp
//
//  Created by MacBook Air on 25.01.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    class func saveTask(_ task: TaskModel) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(task)
            }
        } catch {
            print(error)
        }
    }
    
    class func saveTasks(_ tasks: [TaskModel]) {
        do {
            let realm = try Realm()
            
            let oldTasks = realm.objects(TaskModel.self)
            
            try realm.write {
                realm.delete(oldTasks)
                realm.add(tasks)
            }
            
        } catch {
            print(error)
        }
    }
    
    class func loadTasks() -> Results<TaskModel>? {
        do {
            let realm = try Realm()
            let tasks = realm.objects(TaskModel.self)
            return tasks
        } catch {
            print(error)
            return nil
        }
    }
    
    class func updateTask(title: String) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(TaskModel.self).filter("title == '\(title)'")
            
            if let task = tasks.first {
                try realm.write {
                    task.isCompleted = !task.isCompleted
                }
            }
            
        } catch {
            print("error")
        }
    }
    
}
