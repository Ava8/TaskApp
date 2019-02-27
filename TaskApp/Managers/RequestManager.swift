//
//  RequestManager.swift
//  TaskApp
//
//  Created by MacBook Air on 02.02.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol RequestManagerDelegate {
    func updateTasks()
}

class RequestManager {
    
    private let apiURL = "https://ruby-todolist-app.herokuapp.com/todos.json"
    var delegate: RequestManagerDelegate?
    
    func getRequest() {
        Alamofire.request(apiURL, method: .get).responseData {
            response in guard let data = response.value else {return}
            if let json = try? JSON(data: data) {
                // json[0] - home tasks
                // json[1] - work tasks
                // json[2] - relax tasks
                let homeTasks = json[0]["todos"].compactMap{TaskModel(json: $0.1, cathegory: 0)}
                let workTasks = json[1]["todos"].compactMap{TaskModel(json: $0.1, cathegory: 1)}
                let relaxTasks = json[2]["todos"].compactMap{TaskModel(json: $0.1, cathegory: 2)}
                DBManager.saveTasks(homeTasks+workTasks+relaxTasks)
                DispatchQueue.main.async(execute: {()-> Void in self.delegate?.updateTasks() })
            } else {
                print("wrong json")
            }
        }
    }
    func postRequest(taskTitle: String, cathegory: Int) {
        let params: Parameters = [
            "todo": [
                "projectID": cathegory+1,
                "text": taskTitle
            ]
        ]
        
        Alamofire.request(apiURL, method: .post, parameters: params).validate().responseJSON {
            responseJSON in
            if responseJSON.result.isSuccess == true {
                DBManager.saveTask(TaskModel(taskTitle,cathegory))
                DispatchQueue.main.async(execute: {()-> Void in
                    self.delegate?.updateTasks()
                })
            } else {
                print("wrong post request")
            }
        }
    }
    func putRequest(task: String, state: Bool, id: Int) {
        let params: NSMutableDictionary = [
            "todo": [
                "state": state
            ]
        ]

        let url = NSURL(string: "https://ruby-todolist-app.herokuapp.com/todos/\(id).json")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                if let json = json {
                    print(json)
                }
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
       
         Alamofire.request(request).responseString {
            response in
            print(response.result.isSuccess)
            if response.result.isSuccess == true {
                DBManager.updateTask(title: task)
                DispatchQueue.main.async(execute: {()-> Void in
                    self.delegate?.updateTasks()
                })
            } else {
                print("wrong put request")
            }
        }
    }

}

