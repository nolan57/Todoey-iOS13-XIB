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
    var dataFilePath:URL?
    var itemArray = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        if FileManager().fileExists(atPath: dataFilePath!.path) == false {
            saveItems()
        }
    
        do{
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([TodoItem].self, from: data)
        }
        catch{
            let alert = UIAlertController(title: "Error", message: "Fail to get todos", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
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
        return itemCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let itemCell = tableView.cellForRow(at: indexPath) else { return }
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
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].done = itemCell.accessoryType == .checkmark ? true : false
        saveItems()
    }
    @IBAction func toAdd(_ sender: UIBarButtonItem) {
        
        addBarButton.isEnabled = false
        
        let addNewTodoView = AddNewTodoView.loadXib() as! AddNewTodoView
        
        addNewTodoView.frame = CGRect(origin: CGPoint(x: self.tableView.center.x-tableView.bounds.width / 2, y: self.tableView.center.y-tableView.bounds.height / 4), size: addNewTodoView.bounds.size)
        addNewTodoView.delegate = self
        self.tableView.addSubview(addNewTodoView)
    }
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)}
        catch{
            let alert = UIAlertController(title: "Error", message: "Fail to add new todo", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
}

extension ToDoListViewController:addNewItem{
    func add(what: TodoItem) {
        self.itemArray.append(what)
        self.tableView.reloadData()
        self.addBarButton.isEnabled = true
        saveItems()
    }
    
    func setAddBarButton(){
        self.addBarButton.isEnabled = true
    }
}

