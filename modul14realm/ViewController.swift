//
//  ViewController.swift
//  modul14realm
//
//  Created by Байсаев Зубайр on 12.02.2022.
//

import UIKit
import RealmSwift

//MARK:  Realm Task
class TaskSwift: Object {
    @objc dynamic var task = ""
    @objc dynamic var completed = false
}

//MARK: ViewController
class ViewController: UIViewController {
    
    //MARK: Outlets and Objects
    let realm = try! Realm()
   
    @IBOutlet weak var tableView: UITableView!
    
    var items: Results<TaskSwift>!
    
    var deleteItemsIndexPath: NSIndexPath? = nil
    var cellId = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //MARK: Navigation Bar
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 21/255,
                                                                   green: 101/255,
                                                                   blue: 192/255,
                                                                   alpha: 1)
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addItem))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        
        items = realm.objects(TaskSwift.self)
        
        
    }
   
   
    
    
    //MARK: Add and save new items, Alert
    @objc func addItem(_ sender: AnyObject) {
        
        
        addAlertForNewItem()
    }
    func addAlertForNewItem() { //Add new task in TableView
          
        let alert = UIAlertController(title: "new task", message: "fill the gap", preferredStyle: .alert)
        
        var alertTextField: UITextField!
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "new task"
        }
        
        
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
           //Save new task
            guard let text = alertTextField.text , !text.isEmpty else { return }
            
            let task = TaskSwift()
            task.task = text
            
            try! self.realm.write {
                self.realm.add(task)
            }
        
        
            self.tableView.insertRows(at: [IndexPath.init(row: self.items.count-1, section: 0)], with: .automatic)
           
        }
        
        self.present(alert, animated: true, completion: nil)
        
        //Cancel Adding new task
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        }

    //MARK: Delete objects Realm
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //Setting swipe to delete function

    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {
//          [weak self]  (_,_,_) in
//            guard let self = self  else {return}
//            let editingRow = self.items[indexPath.row]
//            if editingStyle == .delete {
//
//                            try! self.realm.write {
//                                self.realm.delete(editingRow) //Can't delete row and object
//
//                                tableView.reloadData()
//                            }
//
//                        }
//        }
//        }
}

//MARK: DataSource
    extension ViewController: UITableViewDataSource {
        
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if items.count != 0 {
        return items.count
    } else {
        return 0}
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.task
        return cell
    }
    }

extension ViewController:UITableViewDelegate {
  

//    private  func deleteRealm(delete:TaskSwift){
//        
//        
//        let realm = try! Realm()
//
//        try! realm.write {
//
//            realm.delete(delete)
//
//        }}
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editingrow = items[indexPath.row]
        let deleteaction = UITableViewRowAction(style: .destructive, title: "delete", handler: {(action, indexPath) -> Void in
            
            try! self.realm.write {
                self.realm.delete(editingrow)
                tableView.reloadData()
            }
    
        })
        deleteaction.backgroundColor = .red
        return [deleteaction]
        }
    
}

    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//
//    //MARK: DeleteFuncDelegate
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let editingRow = self.items[indexPath.row]
//        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {
//            [weak self] ( action, view, completionHandler) in
//
//            if editingStyle == .delete {
//            self?.deleteRealm(delete: editingRow)
//            completionHandler(true)
//                tableView.deleteRows(at: [IndexPath.init(row:indexPath.row, section: indexPath.section)], with: .fade)
//                tableView.reloadData()
//            }}
//
//        deleteAction.backgroundColor = .red
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//            }
//
//
//    }
    

       
    
    



    
