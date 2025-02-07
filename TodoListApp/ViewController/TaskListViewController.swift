//
//  ViewController.swift
//  TodoListApp
//
//  Created by Alexey Efimov on 24.09.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {
    private var taskList: [TodoTask] = []
    private let cellID = "task"
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    private func addNewTask() {
        showAlert()
    }
    
    private func save(taskName: String) {
        storageManager.create(taskName) { task in
            taskList.append(task)
            tableView.insertRows(
                at: [IndexPath(row: self.taskList.count - 1, section: 0)],
                with: .automatic
            )
        }
    }
    
    private func fetchData() {
        storageManager.fetchData { [unowned self] result in
            switch result {
            case .success(let taskList):
                self.taskList = taskList
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
}


// MARK: - Setup UI

private extension TaskListViewController {
    
    func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.milkBlue
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { [unowned self] _ in
                addNewTask()
            }
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
}



// MARK: - UITableViewDataSource
extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension TaskListViewController {
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.delete(task)
        }
    }
    
}


// MARK: - Alert Controller

extension TaskListViewController {
    private func showAlert(task: TodoTask? = nil, completion: (() -> Void)? = nil) {
        let alertFactory = AlertControllerFactory(userAction: task != nil ? .editTask : .newTask, taskTitle: task?.title)
        
        let alert = alertFactory.createAlert { [weak self] taskName in
            if let task, let completion {
                self?.storageManager.update(task, newTitle: taskName)
                completion()
                return
            }
            
            self?.save(taskName: taskName)
        }
        
        present(alert, animated: true)
    }

}
