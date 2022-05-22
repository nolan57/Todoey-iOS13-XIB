//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{

    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var tabelView: UITableView!
    var itemArray = [TodoItem]()
    var handler:Handler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        handler = Handler(dataFile: "Item.plist")
        itemArray = (handler?.loadItems())!
        if handler?.isLoaded == false{
            alert(message: "No todo data yet!")
        }
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        itemCell.textLabel?.text = itemArray[indexPath.row].what
        itemCell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        loadedUI(itemCell: itemCell)
        return itemCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let itemCell = tableView.cellForRow(at: indexPath) else { return }
        selectedChangingUI(itemCell: itemCell)
        itemArray[indexPath.row].done = itemCell.accessoryType == .checkmark ? true : false
        handler?.saveItems(itemArray: itemArray)
        if handler?.isSaved == false {
            alert(message: "Can't add new todo item!")
        }
    }
    @IBAction func toAdd(_ sender: UIBarButtonItem) {
        
        addBarButton.isEnabled = false
        
        let addNewTodoView = AddNewTodoView.loadXib() as! AddNewTodoView
        
        addNewTodoView.frame = CGRect(origin: CGPoint(x: self.tableView.center.x-tableView.bounds.width / 2, y: self.tableView.center.y-tableView.bounds.height / 4), size: addNewTodoView.bounds.size)
        addNewTodoView.delegate = self
        self.tableView.addSubview(addNewTodoView)
    }
    func selectedChangingUI(itemCell:UITableViewCell){
        if(itemCell.accessoryType == .checkmark ){
            itemCell.textLabel?.textColor = UIColor.white
            itemCell.accessoryType = .none
            itemCell.backgroundColor = UIColor.systemBackground
        }else{
            itemCell.accessoryType = .checkmark
            itemCell.textLabel?.textColor = UIColor.systemYellow
            itemCell.tintColor = UIColor.systemYellow
            itemCell.backgroundColor = UIColor.systemBlue
        }
    }
    func loadedUI(itemCell:UITableViewCell){
        if(itemCell.accessoryType == .checkmark ){
            itemCell.textLabel?.textColor = UIColor.systemYellow
            itemCell.tintColor = UIColor.systemYellow
            itemCell.backgroundColor = UIColor.systemBlue
        }else{
            itemCell.textLabel?.textColor = UIColor.white
            itemCell.backgroundColor = UIColor.systemBackground
        }
    }
    func alert(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}

extension ToDoListViewController:addNewItem{
    func add(what: TodoItem) {
        self.itemArray.append(what)
        self.tableView.reloadData()
        self.addBarButton.isEnabled = true
        handler?.saveItems(itemArray: itemArray)
    }
    
    func setAddBarButton(){
        self.addBarButton.isEnabled = true
    }
}

