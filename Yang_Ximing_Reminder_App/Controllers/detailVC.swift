//
//  detailVC.swift
//  Yang_Ximing_Reminder_App
//
//  Created by Ximing Yang on 2019-04-04.
//  Copyright © 2019 Period Four. All rights reserved.
//

import UIKit
import UserNotifications

class detailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var editView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var descriptionTF: UITextField!
    @IBOutlet var pushNotificationSwitch: UISwitch!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var markDoneSwitch: UISwitch!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet var sortView: UIView!
    @IBOutlet var sortByName: UIButton!
    @IBOutlet var sortByTime: UIButton!
    
    
    var name = ""
    var descript = ""
    var pushNotification = false
    var activity = Reminder(name: "", description: "", push: false)
    var currentRow = 0
    
    var rowSelected = 0
    var segmentIndex = 0
    var canEdit = false
    
    var visualEffect: UIVisualEffect!
    
    override func viewWillAppear(_ animated: Bool) {
        detailTable.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTable.layer.cornerRadius = 25
        detailTable.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg.jpg"))
        detailTable.separatorColor = UIColor.gray
        cancelButton.layer.cornerRadius = 15
        saveButton.layer.cornerRadius = 15
        
        sortByName.layer.cornerRadius = 15
        sortByTime.layer.cornerRadius = 15
        
        visualEffect = visualEffectView.effect
        visualEffectView.effect = nil
        
        timePicker.minimumDate = NSDate() as Date
        timePicker.locale = NSLocale.current
        
        print(categories[rowSelected])
    }
    
    func animateIn() {
        self.view.bringSubviewToFront(visualEffectView)
        self.view.addSubview(editView)
        editView.center.x = self.view.center.x
        editView.center.y = self.view.center.y + 30
        editView.layer.cornerRadius = 15
        nameTF.text = ""
        descriptionTF.text = ""
        
        editView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        editView.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.effect = self.visualEffect
            self.editView.alpha = 1
            self.editView.transform = CGAffineTransform.identity
        })
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.editView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.editView.alpha = 0
            self.visualEffectView.effect = nil
        }, completion: { (success: Bool) in
            self.view.sendSubviewToBack(self.visualEffectView)
            self.editView.removeFromSuperview()
        })
    }
    
    func animateIn2() {
        self.view.bringSubviewToFront(visualEffectView)
        self.view.addSubview(sortView)
        sortView.center = self.view.center
        sortView.layer.cornerRadius = 15
        
        sortView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        sortView.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.effect = self.visualEffect
            self.sortView.alpha = 1
            self.sortView.transform = CGAffineTransform.identity
        })
    }
    
    func animateOut2() {
        UIView.animate(withDuration: 0.3, animations: {
            self.sortView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.sortView.alpha = 0
            self.visualEffectView.effect = nil
        }, completion: { (success: Bool) in
            self.view.sendSubviewToBack(self.visualEffectView)
            self.sortView.removeFromSuperview()
        })
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
    
    
    
    func sortArrayByName() {
        if segmentIndex == 0 {
            if categories[rowSelected].reminderItems.count > 1 {
                for index1 in 0..<categories[rowSelected].reminderItems.count {
                    var temp = index1
                    for index2 in (temp + 1)..<categories[rowSelected].reminderItems.count {
                        if categories[rowSelected].reminderItems[index2].name < categories[rowSelected].reminderItems[index1].name {
                            temp = index2
                        }
                    }
                    
                    if temp != index1 {
                        categories[rowSelected].reminderItems.swapAt(temp, index1)
                    }
                }
            }
        } else if segmentIndex == 1 {
            if categories[rowSelected].doneItems.count > 1 {
                for index1 in 0..<categories[rowSelected].doneItems.count {
                    var temp = index1
                    for index2 in (index1 + 1)..<categories[rowSelected].doneItems.count {
                        if categories[rowSelected].doneItems[index2].name < categories[rowSelected].doneItems[index1].name {
                            temp = index2
                        }
                    }
                    
                    if temp != index1 {
                        categories[rowSelected].doneItems.swapAt(temp, index1)
                    }
                }
            }
        }
        
    }
    
    
    func sortArrayByTime() {
        if segmentIndex == 0 {
            if categories[rowSelected].reminderItems.count > 1 {
                for index1 in 0..<categories[rowSelected].reminderItems.count {
                    var temp = index1
                    for index2 in (index1 + 1)..<categories[rowSelected].reminderItems.count {
                        if categories[rowSelected].reminderItems[index2].time! < categories[rowSelected].reminderItems[index1].time! {
                            temp = index2
                        }
                    }
                    
                    if temp != index1 {
                        categories[rowSelected].reminderItems.swapAt(temp, index1)
                    }
                }
            }
        } else if segmentIndex == 1 {
            if categories[rowSelected].doneItems.count > 1 {
                for index1 in 0..<categories[rowSelected].doneItems.count {
                    var temp = index1
                    for index2 in (index1 + 1)..<categories[rowSelected].doneItems.count {
                        if categories[rowSelected].doneItems[index2].time! < categories[rowSelected].doneItems[index1].time! {
                            temp = index2
                        }
                    }
                    
                    if temp != index1 {
                        categories[rowSelected].doneItems.swapAt(temp, index1)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toCreate", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreate" {
            let addVC = segue.destination as! createActivityVC
            addVC.rowSelected = self.rowSelected
        }
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        animateOut()
    }
    
    @IBAction func saveActivity(_ sender: UIButton) {
        guard nameTF.text != "" else {return}
        name = nameTF.text!
        
        if let des = descriptionTF.text {
            descript = des
        }
        let time = timePicker.date
        pushNotification = pushNotificationSwitch.isOn
        
        if segmentIndex == 0 {
            categories[rowSelected].reminderItems[currentRow].changeName(newName: name)
            categories[rowSelected].reminderItems[currentRow].changeNotificaiton(newPush: pushNotification)
            categories[rowSelected].reminderItems[currentRow].changeDescription(newDescription: descript)
            categories[rowSelected].reminderItems[currentRow].changeTime(newTime: time)
            categories[rowSelected].reminderItems[currentRow].isDone = markDoneSwitch.isOn
        } else if segmentIndex == 1 {
            categories[rowSelected].doneItems[currentRow].changeName(newName: name)
            categories[rowSelected].doneItems[currentRow].changeNotificaiton(newPush: pushNotification)
            categories[rowSelected].doneItems[currentRow].changeDescription(newDescription: descript)
            categories[rowSelected].doneItems[currentRow].changeTime(newTime: time)
            categories[rowSelected].doneItems[currentRow].isDone = markDoneSwitch.isOn
        }
        
        
        if segmentIndex == 0 && markDoneSwitch.isOn == true {
            categories[rowSelected].doneItems.append(categories[rowSelected].reminderItems.remove(at: currentRow))
        }
        
        if segmentIndex == 1 && markDoneSwitch.isOn == false {
            categories[rowSelected].reminderItems.append(categories[rowSelected].doneItems.remove(at: currentRow))
        }
        
        detailTable.reloadData()
        animateOut()
        
        if pushNotification {
            createLocalNotification(title: categories[rowSelected].reminderItems[currentRow].name, body: categories[rowSelected].reminderItems[currentRow].description, date: categories[rowSelected].reminderItems[currentRow].time!)
        }
        
        categories[rowSelected].saveCategory()
        print(categories[rowSelected])
    }
    
    @IBAction func displayTime(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        displayLabel.text = dateFormatter.string(from: timePicker.date)
    }
    
    @IBAction func unwindToDetail(unwind: UIStoryboardSegue) {}
    
    @IBAction func enableEditing(_ sender: UIBarButtonItem) {
        canEdit = !canEdit
        detailTable.setEditing(canEdit, animated: true)
    }
    
    @IBAction func changeSection(_ sender: UISegmentedControl) {
        segmentIndex = segmentControl.selectedSegmentIndex
        
        detailTable.reloadData()
    }
    
    @IBAction func arrangeButton(_ sender: UIBarButtonItem) {
        animateIn2()
    }
    
    @IBAction func confirmSort(_ sender: UIButton) {
        if sender == sortByName {
            for _ in 0...3 {
                sortArrayByName()
            }
        } else if sender == sortByTime {
            sortArrayByTime()
        }
        
        detailTable.reloadData()
        categories[rowSelected].saveCategory()
        animateOut2()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentIndex == 0 {
            return categories[rowSelected].reminderItems.count
        } else {
            return categories[rowSelected].doneItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if segmentIndex == 0 {
            cell?.textLabel?.text = categories[rowSelected].reminderItems[indexPath.row].name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
            let timeText = dateFormatter.string(from: categories[rowSelected].reminderItems[indexPath.row].time!)
            let detailText = categories[rowSelected].reminderItems[indexPath.row].description + "     " + timeText
            cell?.detailTextLabel?.text = detailText
        } else if segmentIndex == 1 {
            cell?.textLabel?.text = categories[rowSelected].doneItems[indexPath.row].name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
            let timeText = dateFormatter.string(from: categories[rowSelected].doneItems[indexPath.row].time!)
            let detailText = categories[rowSelected].doneItems[indexPath.row].description + "     " + timeText
            cell?.detailTextLabel?.text = detailText
        }
        
        cell?.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
        cell?.detailTextLabel?.font = UIFont(name: "Avenir Next", size: 13)
        
        cell?.backgroundColor = UIColor.clear
        cell?.tintColor = UIColor.clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animateIn()
        if segmentIndex == 0 {
            nameTF.text = categories[rowSelected].reminderItems[indexPath.row].name
            descriptionTF.text = categories[rowSelected].reminderItems[indexPath.row].description
            pushNotificationSwitch.isOn = categories[rowSelected].reminderItems[indexPath.row].pushNotificaiton
            timePicker.date = categories[rowSelected].reminderItems[indexPath.row].time!
            markDoneSwitch.isOn = categories[rowSelected].reminderItems[indexPath.row].isDone
        } else if segmentIndex == 1 {
            nameTF.text = categories[rowSelected].doneItems[indexPath.row].name
            descriptionTF.text = categories[rowSelected].doneItems[indexPath.row].description
            pushNotificationSwitch.isOn = categories[rowSelected].doneItems[indexPath.row].pushNotificaiton
            timePicker.date = categories[rowSelected].doneItems[indexPath.row].time!
            markDoneSwitch.isOn = categories[rowSelected].doneItems[indexPath.row].isDone
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        displayLabel.text = dateFormatter.string(from: timePicker.date)
        currentRow = indexPath.row
//        print(currentRow)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if segmentIndex == 0 {
                categories[rowSelected].reminderItems.remove(at: indexPath.row)
                categories[rowSelected].saveCategory()
                detailTable.deleteRows(at: [indexPath], with: .fade)
            } else if segmentIndex == 1 {
                categories[rowSelected].doneItems.remove(at: indexPath.row)
                categories[rowSelected].saveCategory()
                detailTable.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if segmentIndex == 0 {
            let moveObject = categories[rowSelected].reminderItems[sourceIndexPath.row]
            categories[rowSelected].reminderItems.remove(at: sourceIndexPath.row)
            categories[rowSelected].reminderItems.insert(moveObject, at: destinationIndexPath.row)
        } else if segmentIndex == 1 {
            let moveObject = categories[rowSelected].doneItems[sourceIndexPath.row]
            categories[rowSelected].doneItems.remove(at: sourceIndexPath.row)
            categories[rowSelected].doneItems.insert(moveObject, at: destinationIndexPath.row)
        }
    }

}
