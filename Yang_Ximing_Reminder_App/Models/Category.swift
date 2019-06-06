//
//  Category.swift
//  Yang_Ximing_Reminder_App
//
//  Created by Period Four on 2019-04-04.
//  Copyright © 2019 Period Four. All rights reserved.
//

import Foundation
import UIKit

struct Category: Codable {
    
    var name: String = ""
    var description: String = ""
    var icon: String = ""
    var reminderItems: [Reminder] = []
    var doneItems: [Reminder] = []
    
    init(name: String, description: String, icon: String) {
        self.name = name
        self.description = description
        self.icon = icon
    }
    
    mutating func addItem(item: Reminder) {
        reminderItems.append(item)
    }
    
    func saveCategory() {
        DataManager.save(self, with: self.name)
    }
    
    func deleteCategory() {
        DataManager.delete(self.name)
    }
}
