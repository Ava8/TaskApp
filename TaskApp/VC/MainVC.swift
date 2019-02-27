//
//  MainVC.swift
//  TaskApp
//
//  Created by MacBook Air on 25.01.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {
    
    let requestManager = RequestManager()
    
    // MARK: Properties
    @IBOutlet weak var homeTaskTable: UITableView!
    @IBOutlet weak var workTaskTable: UITableView!
    @IBOutlet weak var relaxTaskTable: UITableView!
    
    var homeTasks: Results<TaskModel>?
    var workTasks: Results<TaskModel>?
    var relaxTasks: Results<TaskModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManager.delegate = self
        requestManager.getRequest()
        
        let tasks = DBManager.loadTasks()
        homeTasks = tasks?.filter("cathegory == 0")
        workTasks = tasks?.filter("cathegory == 1")
        relaxTasks = tasks?.filter("cathegory == 2")
        
        homeTaskTable.delegate = self
        homeTaskTable.dataSource = self
        workTaskTable.delegate = self
        workTaskTable.dataSource = self
        relaxTaskTable.delegate = self
        relaxTaskTable.dataSource = self
    }
    
    
}

extension MainVC: UITableViewDelegate {
    
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 1:
            return homeTasks!.count
        case 2:
            return workTasks!.count
        case 3:
            return relaxTasks!.count
        default:
            return 0
        }
    }
    
    
    func strikeTroughText(_ text: String, strike: Bool) -> NSAttributedString {
        if strike == true {
            return NSAttributedString(string: text, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue])
        } else {
            return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir Next Medium", size: 19.0)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as? HomeTaskTVCell else {
                return UITableViewCell()
            }
            let model = homeTasks![indexPath.row]
            cell.taskLabel!.text = model.title
            cell.selectionStyle = .none
            
            if model.isCompleted == true {
                cell.taskLabel.attributedText = strikeTroughText(cell.taskLabel.text!, strike: true)
                cell.checkBox.imageView?.image = #imageLiteral(resourceName: "checked")
            } else if model.isCompleted == false {
                cell.taskLabel.attributedText = strikeTroughText(cell.taskLabel.text!, strike: false)
                cell.checkBox.imageView?.image = #imageLiteral(resourceName: "unchecked")
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "workCell", for: indexPath) as? WorkTaskTVCell else {
                return UITableViewCell()
            }
            let model = workTasks![indexPath.row]
            cell.taskLabel!.text = model.title
            cell.selectionStyle = .none
            
            if model.isCompleted == true {
                cell.taskLabel.attributedText = strikeTroughText(cell.taskLabel.text!, strike: true)
                cell.checkBox.imageView?.image = #imageLiteral(resourceName: "checked")
            } else if model.isCompleted == false {
                cell.taskLabel.attributedText = strikeTroughText(cell.taskLabel.text!, strike: false)
                cell.checkBox.imageView?.image = #imageLiteral(resourceName: "unchecked")
            }
            
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "relaxCell", for: indexPath) as? RelaxTaskTVCell else {
                return UITableViewCell()
            }
            let model = relaxTasks![indexPath.row]
            cell.taskLabel!.text = model.title
            cell.selectionStyle = .none
            
            if model.isCompleted == true {
               cell.taskLabel.attributedText = strikeTroughText(cell.taskLabel.text!, strike: true)
                cell.checkBox.imageView?.image = #imageLiteral(resourceName: "checked")
            } else if model.isCompleted == false {
                cell.taskLabel.attributedText = strikeTroughText(cell.taskLabel.text!, strike: false)
                cell.checkBox.imageView?.image = #imageLiteral(resourceName: "unchecked")
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch tableView.tag {
        case 1:
            let taskTitle = homeTasks![indexPath.row].title
            let taskCompletion = homeTasks![indexPath.row].isCompleted
            let id = homeTasks![indexPath.row].id
            requestManager.putRequest(task: taskTitle, state: !taskCompletion, id: id)
        case 2:
            let taskTitle = workTasks![indexPath.row].title
            let taskCompletion = workTasks![indexPath.row].isCompleted
            let id = workTasks![indexPath.row].id
            requestManager.putRequest(task: taskTitle, state: !taskCompletion, id: id)
        case 3:
            let taskTitle = relaxTasks![indexPath.row].title
            let taskCompletion = relaxTasks![indexPath.row].isCompleted
            let id = relaxTasks![indexPath.row].id
            requestManager.putRequest(task: taskTitle, state: !taskCompletion, id: id)
        default:
            print("upd error")
        }
    }
    
}

extension MainVC: AddTaskDelegate {
    func addTask(_ task: String, _ cathegory: Int) {
        requestManager.postRequest(taskTitle: task, cathegory: cathegory)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddTaskVC
        vc.delegate = self
    }
}

extension MainVC: RequestManagerDelegate {
    func updateTasks() {
        homeTaskTable.reloadData()
        workTaskTable.reloadData()
        relaxTaskTable.reloadData()
    }
    
    
}


