//
//  AddNewTodoView.swift
//  Todoey
//
//  Created by wuqiang on 2022/5/21.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

//@IBDesignable
class AddNewTodoView: UIView {
    
    var delegate:addNewItem?
    static var contentView:AddNewTodoView!
        
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var whatTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    class func loadXib()->UIView{
        self.contentView =  Bundle.main.loadNibNamed("AddNewTodoView", owner: self, options: nil)?.last as? AddNewTodoView
        defaut()
        return contentView
    }
    
    private class func defaut(){
        AddNewTodoView.contentView.whatTextField.backgroundColor =
            UIColor(red: 0.90, green: 0.49, blue: 0.13, alpha: 1.00)
        AddNewTodoView.contentView.backView.layer.cornerRadius = AddNewTodoView.contentView.backView.frame.height / 5
        AddNewTodoView.contentView.addButton.layer.cornerRadius = AddNewTodoView.contentView.addButton.frame.height / 4
        AddNewTodoView.contentView.cancelButton.layer.cornerRadius = AddNewTodoView.contentView.cancelButton.frame.height / 4
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
            if whatTextField.text == ""{
                return
            }
            if let todo = whatTextField.text{
                delegate!.add(what:todo)
            }
            removeFromSuperview()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        delegate?.setAddBarButton()
        removeFromSuperview()
    }
    
}
protocol addNewItem {
    func add(what:String) -> Void
    func setAddBarButton()->Void
}
