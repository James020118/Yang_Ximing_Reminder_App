//
//  Reminder.swift
//  Yang_Ximing_Reminder_App
//
//  Created by Period Four on 2019-04-03.
//  Copyright © 2019 Period Four. All rights reserved.
//

import Foundation
import UIKit

struct Reminder: Codable {
    var name: String = ""
    var description = ""
    var pushNotificaiton = false
    var time: Date?
    var isDone = false
    
    init(name: String, description: String, push: Bool) {
        self.name = name
        self.description = description
        self.pushNotificaiton = push
    }
    
    mutating func changeName(newName: String) {
        name = newName
    }
    
    mutating func changeDescription(newDescription: String) {
        description = newDescription
    }
    
    mutating func changeNotificaiton(newPush: Bool) {
        pushNotificaiton = newPush
    }
    
    mutating func changeTime(newTime: Date) {
        time = newTime
    }
    
}
