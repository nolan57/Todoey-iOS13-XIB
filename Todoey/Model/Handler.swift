//
//  Handler.swift
//  Todoey
//
//  Created by wuqiang on 2022/5/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit

struct Handler {
    var dataFilePath:URL
    var itemArray:[TodoItem]
    var isLoaded:Bool
    var isSaved:Bool
    
    init(dataFile:String) {
        dataFilePath = (FileManager.default.urls(
                            for: .documentDirectory,
                            in: .userDomainMask)
                            .first?
                            .appendingPathComponent(dataFile))!
        itemArray = [TodoItem]()
        isLoaded = false
        isSaved = false
    }
    
    mutating func loadItems()->[TodoItem]{
        if FileManager().fileExists(atPath: dataFilePath.path) == false {
            print("no dat file founded!")
            saveItems(itemArray: itemArray)
        }
        do{
            let data = try Data(contentsOf: dataFilePath)
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([TodoItem].self, from: data)
            isLoaded = true
        }
        catch{
            isLoaded = false
        }
        return itemArray
    }
    
    mutating func saveItems(itemArray:[TodoItem]){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath)
            isSaved = true
        }
        catch{
            isSaved = false
        }
    }
}
