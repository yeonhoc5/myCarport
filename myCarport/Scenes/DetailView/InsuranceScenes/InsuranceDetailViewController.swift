//
//  InsuranceDetailViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class InsuranceDetailViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var indexOfCar: Int!
    var insurances: [Insurance]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView()
        settingTabBarItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !appDelegate.carList.isEmpty {
            self.insurances = appDelegate.carList[indexOfCar].insurance
        }
    }
    
    func settingTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .clear
    }
    
    func settingTabBarItem() {
        let btnRenewInsurace = UIBarButtonItem(title: "갱신", style: .plain, target: self, action: #selector(renewInsurance))
        navigationItem.rightBarButtonItem = btnRenewInsurace
    }
    @objc func renewInsurance() {
        if appDelegate.carList.count < 1 {
            emptyAlert()
        } else {
            guard let renewInsuranceVC = storyboard?.instantiateViewController(withIdentifier: "InsuranceEditViewController") as? InsuranceEditViewController else { return }
            renewInsuranceVC.titleInsurance = "보험 갱신"
            renewInsuranceVC.indexOfCar = indexOfCar
            renewInsuranceVC.modalPresentationStyle = .fullScreen
            renewInsuranceVC.delegate = self
            navigationController?.present(renewInsuranceVC, animated: true)
        }
    }
    
    func emptyAlert() {
        let emptyAlert = UIAlertController(title: "등록된 차량이 없습니다.", message: "차량 등록 후 이용해 주세요.", preferredStyle: .alert)
        emptyAlert.addAction(UIAlertAction(title: "확인", style: .default))
        present(emptyAlert, animated: true)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return 1
        default:
            if let insurances = insurances {
                if insurances.count < 2 {
                    return 1
                } else {
                    return insurances.count - 1
                }
            } else {
                return 1
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer: String!
        switch indexPath {
        case [0,1], [0,2]: identifer = "DetailOfInsuranceCell"
        case [1,0]: identifer = "CallOfInsuranceCell"
        default: identifer = "CorpOfInsuranceCell"
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifer) as? InsuranceCell else { return UITableViewCell() }
        if insurances == nil {
            switch indexPath.section {
            case 0:
                cell.isUserInteractionEnabled = false
                switch indexPath.row {
                case 0: cell.settingCellCorp(type: .isNil)
                case 1: cell.settingCellMileage(type: .isNil)
                case 2: cell.settingCellPay(type: .isNil)
                default: break
                }
            case 1: cell.settingCellCall(type: .isNil)
            case 2: cell.settingCellCorp(type: .isNil)
            default: break
            }
        } else if insurances.isEmpty {
            switch indexPath.section {
            case 0:
                cell.isUserInteractionEnabled = false
                switch indexPath.row {
                case 0: cell.settingCellCorp(type: .empty, strEmpty: "현재 등록된 보험 정보가 없습니다.")
                case 1: cell.settingCellMileage(type: .empty)
                case 2: cell.settingCellPay(type: .empty)
                default: break
                }
            case 1: cell.settingCellCall(type: .empty)
            case 2: cell.settingCellCorp(type: .empty, strEmpty: "지난 가입 내역이 없습니다.")
            default: break
            }
        } else {
            let insurance = insurances.last
            switch indexPath.section {
            case 0:
                cell.isUserInteractionEnabled = false
                switch indexPath.row {
                case 0: cell.settingCellCorp(type: .last, insurance: insurance)
                case 1: cell.settingCellMileage(type: .last, insurance: insurance)
                case 2: cell.settingCellPay(type: .last, insurance: insurance)
                default: break
                }
            case 1: cell.settingCellCall(type: .last, insurance: insurance)
            case 2:
                if insurances.count < 2 {
                    cell.settingCellCorp(type: .empty, strEmpty: "지난 가입 내역이 없습니다.")
                } else {
                    cell.settingCellCorp(type: .last, insurance: insurances[insurances.count - indexPath.row - 2])
                }
            default: break
            }
        }
        cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1: return 60
        default: return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0, 2: return 30
        default: return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "현재보험"
        case 1: return ""
        default: return "보험 가입 내역"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            if let insurances = insurances {
                guard let EdictVC = storyboard?.instantiateViewController(withIdentifier: "InsuranceEditViewController") as? InsuranceEditViewController else { return }
                EdictVC.insurance = insurances[indexPath.row]
                EdictVC.titleRegistBtn = "수정"
                present(EdictVC, animated: true)
            } else {
                emptyAlert()
            }
        default:
            break
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
