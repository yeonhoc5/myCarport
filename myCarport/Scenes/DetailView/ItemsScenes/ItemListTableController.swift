//
//  ItemListTableController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/12/05.
//

import UIKit
import CoreData

class ItemListTableController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnRegist: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    var cycleList: [Int] = []
//    var isSelected: [Bool] = Array(repeating: false, count: 18)
    var selectedID: [NSManagedObjectID]! {
        didSet {
            self.btnTitle = selectedID.count == 1 ? "1개의 아이템만 갱신하기" : "\(selectedID.count)개의 아이템 갱신하기"
        }
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var indexOfCar: Int!
    var idOfItem: Int!
    
    var maintenance: [Maintenance]!
    var history: ManageHistory!
    
    var delegate: ItemDetailViewController!
    
    var btnTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "관리 기록 함께 갱신하기"
        settingBtns()
        settingTableView()
        view.backgroundColor = tableView.backgroundColor
        
    }
    
    private func settingBtns() {
        [btnRegist, btnCancel].forEach {
            $0.layer.cornerRadius = 10
            $0.tintColor = .white
            $0.backgroundColor = .systemTeal.withAlphaComponent(0.8)
        }
        btnRegist.setTitle("1개의 아이템만 갱신하기", for: .normal)
        btnCancel.setTitle("취소", for: .normal)
    }
    
    private func settingTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        self.cycleList = Array(Set((self.maintenance.compactMap{$0.cycleMileage}))).sorted(by: {$0 < $1})
    }
    
    
    @IBAction func tapBtnRegist(_ sender: UIButton) {
        let dao = CarInfoDAO()
        if dao.addMaintenanceHistory(maintenanaceID: selectedID, history: history) {
            self.presentingViewController?.dismiss(animated: true)
            delegate?.collectionView.reloadData()
            delegate?.addHistory(history)
        }
        
    }
    
    @IBAction func tabBtnCancel(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - Table view data source


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ItemListTableController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.cycleList.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "주기 : \(Funcs.numberToString(number: cycleList[section]))"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.text = headerView.textLabel?.text?.lowercased()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.maintenance.filter{$0.cycleMileage == cycleList[section]}.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell") as? ItemListCell else { return UITableViewCell()}
        cell.tintColor = .systemTeal
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.layer.borderWidth = 0.5
        
        let items = self.maintenance.filter{$0.cycleMileage == cycleList[indexPath.section]}
        cell.lblItemName.text = items[indexPath.row].nameOfItem
        cell.objectID = items[indexPath.row].objectID
        
        if cell.objectID == self.selectedID.first! {
            cell.accessoryType = .checkmark
            cell.isUserInteractionEnabled = false
            cell.lblItemName.textColor = .systemTeal
            cell.lblItemName.font = .systemFont(ofSize: 14, weight: .heavy)
        } else {
            cell.isUserInteractionEnabled = true
            cell.accessoryType = selectedID.contains(cell.objectID) == true ? .checkmark : .none
            cell.lblItemName.textColor = .label
            cell.lblItemName.font = .systemFont(ofSize: 14)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = self.maintenance.filter{$0.cycleMileage == cycleList[indexPath.section]}
        if let objectID = items[indexPath.row].objectID {
            if let index = selectedID.firstIndex(of: objectID) {
                selectedID.remove(at: index)
            } else {
                selectedID.append(objectID)
            }
        }
        self.btnRegist.setTitle(btnTitle, for: .normal)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

