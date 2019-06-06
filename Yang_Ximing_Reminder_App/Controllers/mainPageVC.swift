
import UIKit

let iconImages = [#imageLiteral(resourceName: "study.png"), #imageLiteral(resourceName: "travel.png"), #imageLiteral(resourceName: "reading.png"), #imageLiteral(resourceName: "play.png"), #imageLiteral(resourceName: "business.png"), #imageLiteral(resourceName: "others.png")]

var categories: [Category] = []

class mainPageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet var categoryView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet var iconButtons: [UIButton]!
    var isChosen = false
    
    var effect: UIVisualEffect!
    var name = ""
    var descript = ""
    var icon: String?
    
    var rowSelected = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        cancelButton.layer.cornerRadius = 15
        saveButton.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categories = DataManager.loadAll(Category.self)
        print(categories)
    }
    
    func setUpTable() {
        mainTable.separatorColor = UIColor.gray
        mainTable.layer.cornerRadius = 25
        mainTable.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg2.jpg"))
    }
    
    func animateIn() {
        self.view.bringSubviewToFront(visualEffectView)
        self.view.addSubview(categoryView)
        categoryView.center = self.view.center
        categoryView.layer.cornerRadius = 15
        nameTF.text = ""
        descriptionTF.text = ""
        
        categoryView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        categoryView.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.effect = self.effect
            self.categoryView.alpha = 1
            self.categoryView.transform = CGAffineTransform.identity
            })
        
        isChosen = false
        for index in 0...5 {
            iconButtons[index].isHidden = false
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.categoryView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.categoryView.alpha = 0
            self.visualEffectView.effect = nil
        }, completion: { (success: Bool) in
            self.view.sendSubviewToBack(self.visualEffectView)
            self.categoryView.removeFromSuperview()
            })
    }

    @IBAction func createCategory(_ sender: UIBarButtonItem) {
        animateIn()
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
    }
    
    @IBAction func chooseIcon(_ sender: UIButton) {
        if isChosen == false {
            let tag = sender.tag
            switch tag {
            case 0:
                icon = "study"
            case 1:
                icon = "travel"
            case 2:
                icon = "reading"
            case 3:
                icon = "play"
            case 4:
                icon = "business"
            case 5:
                icon = "others"
            default:
                icon = ""
            }
            
            for index in 0...5 {
                if iconButtons[index].tag != tag {
                    iconButtons[index].isHidden = true
                }
            }
            isChosen = true
        } else {
            icon = ""
            for index in 0...5 {
                iconButtons[index].isHidden = false
            }
            isChosen = false
        }
    }
    
    @IBAction func saveAndDismiss(_ sender: UIButton) {
        guard nameTF.text != "" else {return}
        
        name = nameTF.text!
        if let des = descriptionTF.text {
            descript = des
        }
        
        let category = Category(name: name, description: descript, icon: icon ?? "others")
        category.saveCategory()
        categories.append(category)
        animateOut()
        mainTable.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail = segue.destination as! detailVC
        detail.navigationItem.title = name
        detail.rowSelected = rowSelected
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = categories[indexPath.row].name
        cell?.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
        cell?.detailTextLabel?.text = categories[indexPath.row].description
        cell?.detailTextLabel?.font = UIFont(name: "Avenir Next", size: 13)
        
        switch categories[indexPath.row].icon {
        case "study":
            cell?.imageView?.image = iconImages[0]
        case "travel":
            cell?.imageView?.image = iconImages[1]
        case "reading":
            cell?.imageView?.image = iconImages[2]
        case "play":
            cell?.imageView?.image = iconImages[3]
        case "business":
            cell?.imageView?.image = iconImages[4]
        case "others":
            cell?.imageView?.image = iconImages[5]
        default:
            cell?.imageView?.image = iconImages[5]
        }
        
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        name = categories[indexPath.row].name
        rowSelected = indexPath.row
        performSegue(withIdentifier: "goToDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Category", message: "Are you sure that you want to delete this category?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                DataManager.delete(categories[indexPath.row].name)
                categories.remove(at: indexPath.row)
                self.mainTable.deleteRows(at: [indexPath], with: .fade)
                }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
