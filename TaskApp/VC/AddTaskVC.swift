//
//  AddTaskVC.swift
//  TaskApp
//
//  Created by MacBook Air on 25.01.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit

protocol AddTaskDelegate {
    func addTask(_ task: String, _ cathegory: Int)
}

class AddTaskVC: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var taskText: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstarint: NSLayoutConstraint!
    
    var delegate: AddTaskDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskText.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    // MARK: Actions
    
    @objc func keyboardWillShow(with notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        guard let keyboardFrame = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size else {return}
        
        let keyboardHeight = keyboardFrame.height
        bottomConstarint.constant = -keyboardHeight-10
        
        UIView.animate(withDuration: 0.3){self.view.layoutIfNeeded()}
    }
    
    @IBAction func done(_ sender: Any) {
        if taskText.text != "" {
            delegate?.addTask(taskText.text, segmentedControl.selectedSegmentIndex)
        }
        dismiss(animated: true)
        taskText.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
        taskText.resignFirstResponder()
    }
}

extension AddTaskVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if doneButton.isHidden {
            taskText.text.removeAll()
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3){self.view.layoutIfNeeded()}
        }
    }
}
