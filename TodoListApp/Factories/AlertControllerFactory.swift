//
//  AlertControllerFactory.swift
//  TodoListApp
//
//  Created by Alex Pesenka on 07/02/25.
//

import UIKit

protocol AlertControllerFactoryProtocol {
    func createAlert(completion: @escaping (String) -> Void) -> UIAlertController
}

final class AlertControllerFactory: AlertControllerFactoryProtocol {
    let userAction: UserAction
    let taskTitle: String?
    
    init(userAction: UserAction, taskTitle: String?) {
        self.userAction = userAction
        self.taskTitle = taskTitle
    }
    
    func createAlert(completion: @escaping (String) -> Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: userAction.title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alertController.textFields?.first?.text else { return }
            guard !task.isEmpty else { return }
            completion(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { textField in
            textField.placeholder = "Task"
            textField.text = self.taskTitle
        }
        
        
        
        return alertController
    }
    
    
}




// MARK: - UserAction
extension AlertControllerFactory {
    enum UserAction {
        case newTask
        case editTask
        
        var title: String {
            switch self {
            case .newTask:
                return "New Task"
            case .editTask:
                return "Edit Task"
            }
        }
    }
}
