//
//  ItemListTableController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/12/05.
//

import UIKit

class ItemListTableController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnRegist: UIButton!
    
    var cycleList: [Int] = [5000, 10000, 30000, 40000, 50000, 60000, 80000, 100000, 120000]
    var cycleTitle: [String] = ["5천", "1만", "3만", "4만", "5만", "6만", "8만", "1십만", "12만"]
    var isSelected: [Bool] = Array(repeating: false, count: 18)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var indexOfCar: Int!
    var idOfItem: Int!
    var history: ManageHistory!
    
    var delegate: ItemDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "관리 기록 함께 갱신하기"
        settingBtnRenew()
        settingTableView()
        view.backgroundColor = tableView.backgroundColor
        
    }
    
    private func settingBtnRenew() {
        btnRegist.layer.cornerRadius = 10
        btnRegist.tintColor = .white
        btnRegist.backgroundColor = .btnTealBackground
        btnRegist.setTitle("갱신하기", for: .normal)
    }
    
    private func settingTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @IBAction func tapBtnRegist(_ sender: UIButton) {
        for i in 0..<isSelected.count {
            if isSelected[i] {
                appDelegate.carList[indexOfCar].maintenance[i].historyManage.append(self.history)
            }
        }
        delegate.maintenance = appDelegate.carList[indexOfCar].maintenance[idOfItem]
        delegate.collectionView.reloadData()
        self.presentingViewController?.dismiss(animated: true)
        delegate.navigationController?.popToRootViewController(animated: true)
        
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
        return "주기 : \(self.cycleTitle[section])km"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.text = headerView.textLabel?.text?.lowercased()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appDelegate.itemList.filter{$0.1 == self.cycleList[section]}.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell") as? ItemListCell else { return UITableViewCell()}
        cell.tintColor = .systemTeal
        cell.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.layer.borderWidth = 0.5
        
        let items = appDelegate.itemList.filter{$0.1 == cycleList[indexPath.section]}
        cell.lblItemName.text = items[indexPath.row].0
        if let index = appDelegate.itemList.firstIndex(where: { $0.0 == items[indexPath.row].0 }) {
            if index == idOfItem {
                cell.accessoryType = .checkmark
                cell.isUserInteractionEnabled = false
                cell.lblItemName.textColor = .systemTeal
                cell.lblItemName.font = .systemFont(ofSize: 14, weight: .heavy)
            } else {
                cell.isUserInteractionEnabled = true
                cell.accessoryType = isSelected[index] == true ? .checkmark : .none
                cell.lblItemName.textColor = .label
                cell.lblItemName.font = .systemFont(ofSize: 14)
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = appDelegate.itemList.filter{$0.1 == cycleList[indexPath.section]}
        if let index = appDelegate.itemList.firstIndex(where: { $0.0 == items[indexPath.row].0 }) {
            if index != idOfItem {
                isSelected[index].toggle()
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

