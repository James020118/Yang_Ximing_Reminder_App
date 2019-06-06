//
//  createActivityVC.swift
//  Yang_Ximing_Reminder_App
//
//  Created by Period Four on 2019-04-10.
//  Copyright © 2019 Period Four. All rights reserved.
//

import UIKit
import UserNotifications

class createActivityVC: UITableViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet var pushNotificationSwitch: UISwitch!
    @IBOutlet var timeDisplayLabel: UILabel!
    @IBOutlet var timePicker: UIDatePicker!
    
    var name = ""
    var descript = ""
    var pushNotification = false
    var activity = Reminder(name: "", description: "", push: false)
    var rowSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.minimumDate = NSDate() as Date
        timePicker.locale = NSLocale.current
    }
    
    @IBAction func saveActivity(_ sender: UIBarButtonItem) {
        guard nameTF.text != "" else {return}
        name = nameTF.text!
        
        if let des = descriptionTF.text {
            descript = des
        }
        let time = timePicker.date
        pushNotification = pushNotificationSwitch.isOn
        activity.changeName(newName: name)
        activity.changeDescription(newDescription: descript)
        activity.changeNotificaiton(newPush: pushNotification)
        activity.changeTime(newTime: time)
        categories[rowSelected].addItem(item: activity)
        
        let row = categories[rowSelected].reminderItems.count - 1
        
        if pushNotification {
            createLocalNotification(title: categories[rowSelected].reminderItems[row].name, body: categories[rowSelected].reminderItems[row].description, date: categories[rowSelected].reminderItems[row].time!)
        }
        categories[rowSelected].saveCategory()
        performSegue(withIdentifier: "unwind", sender: sender)
    }
    
    
    @IBAction func displayTime(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        timeDisplayLabel.text = dateFormatter.string(from: timePicker.date)
    }
    
    func createLocalNotification(title: String, body: String, date: Date) {
        let center = UNUserNotificationCenter.current()
        
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.body = body
        notification.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let identifier = title
        let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print("something went wrong")
            }
        }
    }
}
