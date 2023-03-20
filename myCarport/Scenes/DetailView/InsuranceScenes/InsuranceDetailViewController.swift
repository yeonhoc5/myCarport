//
//  InsuranceDetailViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class InsuranceDetailViewController: UITableViewController {

    var carInfo: CarInfo?
    var insurances: [Insurance]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInsuranceInfo()
        settingTableView()
        settingNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    // 보험 정보 불러오기
    func loadInsuranceInfo() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.insurances = carInfo == nil ? appDelegate.sampleInsurance : carInfo?.insurance
    }
    // 테이블 세팅
    func settingTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .clear
    }
    // 네비게이션 세팅
    func settingNavigationBar() {
        let btnRenewInsurace = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(renewInsurance))
        navigationItem.rightBarButtonItem = btnRenewInsurace
        navigationItem.title = "\(carInfo?.carName ?? "샘플 차량")"
    }
    @objc func renewInsurance() {
        if let _ = self.carInfo {
            guard let renewInsuranceVC = storyboard?.instantiateViewController(withIdentifier: "InsuranceEditViewController") as? InsuranceEditViewController else { return }
            renewInsuranceVC.carInfo = self.carInfo
            renewInsuranceVC.titleInsurance = "보험 갱신"
            renewInsuranceVC.modalPresentationStyle = .fullScreen
            renewInsuranceVC.delegate = self
            navigationController?.present(renewInsuranceVC, animated: true)
        } else {
            emptyAlert()
        }
    }
    // 알럿 1. 차량이 없을 경우
    func emptyAlert() {
        let emptyAlert = UIAlertController(title: "등록된 차량이 없습니다.", message: "차량 등록 후 이용해 주세요.", preferredStyle: .alert)
        emptyAlert.addAction(UIAlertAction(title: "확인", style: .default))
        present(emptyAlert, animated: true)
    }
    // 알럿 2. 보험 내역이 1개일 경우
    func countAlert() {
        let emptyAlert = UIAlertController(title: "이전 가입 내역이 없습니다.", message: "현재 보험 정보를 확인해 주세요.", preferredStyle: .alert)
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
                return insurances.count < 2 ? 1 : (insurances.count - 1)
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
        
        if insurances.isEmpty {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0: cell.settingCellCorp(type: .empty, strEmpty: "현재 등록된 보험 정보가 없습니다.")
                    cell.isUserInteractionEnabled = false
                case 1: cell.settingCellMileage(type: .empty)
                    cell.isUserInteractionEnabled = false
                case 2: cell.settingCellPay(type: .empty)
                    cell.isUserInteractionEnabled = false
                default: break
                }
                cell.backgroundColor = .systemTeal.withAlphaComponent(0.8)
                cell.layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.5).cgColor
                cell.layer.borderWidth = 0.0
            case 1: cell.settingCellCall(type: .empty)
                cell.lblCallNumber.textColor = .secondaryLabel
                cell.backgroundColor = .secondarySystemBackground
                cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
                cell.layer.borderWidth = 0.5
            case 2: cell.settingCellCorp(type: .empty, strEmpty: "지난 가입 내역이 없습니다.")
                cell.backgroundColor = .secondarySystemBackground
                cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
                cell.layer.borderWidth = 0.5
            default: break
            }
            
        } else {
            let insurance = insurances.last
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0: cell.settingCellCorp(type: .last, insurance: insurance)
                case 1: cell.settingCellMileage(type: .last, insurance: insurance)
                    cell.isUserInteractionEnabled = false
                case 2: cell.settingCellPay(type: .last, insurance: insurance)
                    cell.isUserInteractionEnabled = false
                default: break
                }
                cell.backgroundColor = .systemTeal.withAlphaComponent(0.8)
                cell.layer.borderWidth = 0.0
                cell.layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.2).cgColor
            case 1: cell.settingCellCall(type: .last, insurance: insurance)
                cell.backgroundColor = .secondarySystemBackground
                cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
                cell.layer.borderWidth = 0.5
                cell.isUserInteractionEnabled = true
            case 2:
                if insurances.count < 2 {
                    cell.settingCellCorp(type: .empty, strEmpty: "지난 가입 내역이 없습니다.")
                } else {
                    cell.settingCellCorp(type: .last, insurance: insurances[insurances.count - indexPath.row - 2])
                }
                cell.backgroundColor = .secondarySystemBackground
                cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
                cell.layer.borderWidth = 0.5
            default: break
            }
        }
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
        if indexPath.section == 0 {
            return 40
        } else {
            return 50
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "현재보험"
        case 1: return ""
        default: return "보험 가입 내역"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = carInfo {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            switch indexPath.section {
            case 0:
                if insurances.count > 0 {
                    guard let EdictVC = storyboard?.instantiateViewController(withIdentifier: "InsuranceEditViewController") as? InsuranceEditViewController else { return }
                    EdictVC.delegate = self
                    let insuranceToEdit = insurances.last?.objectID == nil ? appDelegate.myCarList.filter({$0.objectID == self.carInfo?.objectID}).first?.insurance.last : self.insurances.last
                    EdictVC.insurance = insuranceToEdit
                    EdictVC.indexOfInsurance = insurances.count - 1
                    EdictVC.titleRegistBtn = "수정"
                    present(EdictVC, animated: true)
                }
            case 1:
                if let index = appDelegate.insuranceCorp.firstIndex(where: { $0.name == insurances.last?.corpName }) {
                    print("step 1")
                    let number = appDelegate.insuranceCorp[index].callNumber
                    guard let url = URL(string: "tel://\("\(number)")"), UIApplication.shared.canOpenURL(url) else {
                        return }
                    print("step 2")
                    UIApplication.shared.open(url)
                    print("step 3")
                }
            case 2:
                if insurances.count > 1 {
                    guard let EdictVC = storyboard?.instantiateViewController(withIdentifier: "InsuranceEditViewController") as? InsuranceEditViewController else { return }
                    let nextIndex = insurances.count - (indexPath.row + 2)
                    EdictVC.delegate = self
                    let insuranceToEdit = insurances[nextIndex].objectID == nil ? appDelegate.myCarList.filter({$0.objectID == self.carInfo?.objectID}).first?.insurance[nextIndex] : self.insurances[nextIndex]
                    EdictVC.insurance = insuranceToEdit
                    EdictVC.indexOfInsurance = nextIndex
                    EdictVC.titleRegistBtn = "수정"
                    present(EdictVC, animated: true)
                } else if insurances.count == 1 {
                    countAlert()
                }
            default:
                break
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            emptyAlert()
//            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return self.insurances.count > 0
            } else {
                return false
            }
        case 2:
            return self.insurances.count > 1
        default:
            return false
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dao = CarInfoDAO()
            let index = indexPath.section == 0 ? (insurances.count - 1) : (insurances.count - indexPath.row - 2)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let insuranceToEdit = insurances[index].objectID != nil ? self.insurances[index] : appDelegate.myCarList.filter({$0.objectID == self.carInfo?.objectID}).first?.insurance[index],
               let objectID = insuranceToEdit.objectID {
                if dao.deleteData(id: objectID) {
                    appDelegate.myCarList = dao.fetch()
                    self.insurances.remove(at: index)
                    if indexPath.row == 0 {
                        tableView.reloadData()
                    } else {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}


extension InsuranceDetailViewController: EditInsurance {
    func editInsurance(type: EditType, index: Int! = 0, insurance: Insurance) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        switch type {
        case .add:
            self.insurances.append(insurance)
        case .modify:
            if let index = index {
                let originalObjectID = insurance.objectID
                self.insurances[index] = insurance
                self.insurances[index].objectID = originalObjectID
            }
        }
        self.insurances =  insurances.sorted(by: {$0.dateStart! < $1.dateStart!})
        UIView.animate(withDuration: 1, delay: 0.5) {
            self.tableView.reloadData()
        }
    }
}
