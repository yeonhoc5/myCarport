//
//  SettingViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit
import SnapKit

class SettingViewController: UITableViewController {
    
    var myCarList: [CarInfo] = [] 
    var isLogin = false
    var btnEditTableView: UIButton!
    
    var isEditingMode: Bool = false // {
//        didSet {
//            UIView.animate(withDuration: 0.25, delay: 0) {
//                self.tableView.isEditing = self.isEditingMode
//            }
//        }
//    }
    
    var delegate: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMyCarList()
    }
    

    func loadMyCarList() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.myCarList = appDelegate.myCarList
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return myCarList.isEmpty ? 1 : myCarList.count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 공통 레이아웃
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingCell") as? SettingCell else { return UITableViewCell() }
            cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
            cell.layer.borderWidth = 0.7
            cell.backgroundColor = .secondarySystemBackground
            if isLogin {
                cell.btnLogin.isHidden = true
                cell.lblLoginGuide.text = "yeonhoc5@gmail.com"
                cell.lblLoginGuide.textAlignment = .center
                cell.btnLogOut.tintColor = .systemTeal
                cell.btnSignOut.tintColor = .systemTeal
            } else {
                cell.lblLoginGuide.text = "로그인하여 \n\n보다 안전하게 데이터를 보호하세요."
                cell.btnLogin.setTitle("로그인 (준비 중)", for: .normal)
                cell.btnLogin.backgroundColor = .systemTeal.withAlphaComponent(0.8)
                cell.btnLogin.tintColor = .systemBackground
                cell.btnLogin.layer.cornerRadius = cell.btnLogin.frame.height / 4
                cell.btnLogin.clipsToBounds = true
                cell.btnLogin.becomeFirstResponder()
                cell.stackBtnOut.isHidden = true
            }
            cell.imgView.image = UIImage(systemName: "person.circle.fill")
            cell.imgView.backgroundColor = .clear
            cell.imgView.tintColor = .systemTeal.withAlphaComponent(0.8)
            cell.imgView.frame.size.width = 50
            cell.lblLoginGuide.textColor = .systemTeal.withAlphaComponent(0.8)
            cell.lblLoginGuide.adjustsFontSizeToFitWidth = true
            cell.lblLoginGuide.numberOfLines = 3
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarSettingCell") as? SettingCell else { return UITableViewCell() }
            cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
            cell.layer.borderWidth = 0.7
            cell.backgroundColor = .secondarySystemBackground
            if myCarList.isEmpty {
                cell.lblCarName.text = "등록된 차량이 없습니다."
                cell.lblCarType.text = ""
                cell.isUserInteractionEnabled = false
            } else {
                let item = myCarList[indexPath.row]
                let fuel = item.typeFuel.rawValue.toTypeFuelString()
                let shift = item.typeShift.rawValue.toTypeShiftString()
                cell.lblCarName.text = "[\(item.carNumber)] \(item.carName)"
                cell.lblCarType.text = "\(fuel) (\(shift))"
                cell.lblCarName.font = .systemFont(ofSize: 15)
                cell.lblCarType.font = .systemFont(ofSize: 15)
                cell.lblCarType.textColor = .secondaryLabel
            }
//            cell.lblCarName.sizeToFit()
//            cell.lblCarType.sizeToFit()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 150
        default: return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "my Car List"
        default:
            return ""
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let title = UILabel()
//        title.text = "myCar List"
//        title.sizeToFit()
//        let editbutton = UIButton()
//        editbutton.setTitle("Edit", for: .normal)
//        editbutton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        editbutton.titleLabel?.textAlignment = .right
//
//        let titleView = UIStackView()
//        [title, editbutton].forEach {
//            titleView.addSubview($0)
//        }
//        title.snp.makeConstraints {
//            $0.leading.equalToSuperview()
//        }
//        editbutton.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(10)
//            $0.verticalEdges.equalTo(title.snp.verticalEdges)
//            $0.width.equalTo(50)
//        }
//
//        editbutton.addTarget(self, action: #selector(doEditingMod), for: .touchUpInside)
//        titleView.frame.size.width = view.frame.width
//        if section == 1 {
//            return titleView
//        } else {
//            return nil
//        }
//    }
//
//    @objc func doEditingMod() {
//        self.isEditingMode.toggle()
//    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return indexPath.section == 1 ? true : false
//    }
//    
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        
//    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let EditCarVC = storyboard?.instantiateViewController(withIdentifier: "AddCarViewController") as? AddAndEditCarViewController else { return }
            EditCarVC.titleForPage = "차량 정보 수정"
            EditCarVC.carInfo = myCarList[indexPath.row]
            EditCarVC.btnTitle = "수정"
            EditCarVC.delegate2 = self
            self.present(EditCarVC, animated: true)
        default:
            break
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 70
        default: return 0
        }
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if myCarList.count > 0 && indexPath.section == 1 {
            return true
        } else {
            return false
        }
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dao = CarInfoDAO()
            if let objectID = myCarList[indexPath.row].objectID {
                if dao.deleteData(id: objectID) {
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.myCarList = dao.fetch()
                    self.myCarList = appDelegate.myCarList
                    if myCarList.count > 1 {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        UIView.animate(withDuration: 0.35, delay: 0.0) {
                            tableView.reloadData()
                        }
                    }
                    delegate.removeAnimationCount(at: indexPath.row)
                    if delegate.myCarList.isEmpty {
                        delegate.tableView.reloadData()
                    }
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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


extension SettingViewController: RenewCarList {
    func renewCarList() {
        self.loadMyCarList()
    }
}
