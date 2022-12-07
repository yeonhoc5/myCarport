//
//  SettingViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class SettingViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var carList: [CarInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemBackground
        carList = appDelegate.carList
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return carList.isEmpty ? 1 : carList.count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingCell") as? SettingCell else { return UITableViewCell() }
            if isLogin {
                cell.btnLogin.isHidden = true
                cell.lblLoginGuide.text = "yeonhoc5@gmail.com"
                cell.lblLoginGuide.textAlignment = .center
                cell.btnLogOut.tintColor = .systemTeal
                cell.btnSignOut.tintColor = .systemTeal
            } else {
                cell.lblLoginGuide.text = "로그인하여 \n\n보다 안전하게 데이터를 보호하세요."
                cell.btnLogin.setTitle("로그인 하러 가기", for: .normal)
                cell.btnLogin.backgroundColor = .btnTealBackground
                cell.btnLogin.tintColor = .systemBackground
                cell.btnLogin.layer.cornerRadius = cell.btnLogin.frame.height / 4
                cell.btnLogin.clipsToBounds = true
                cell.btnLogin.becomeFirstResponder()
                cell.stackBtnOut.isHidden = true
            }
            cell.imgView.image = UIImage(systemName: "person.circle.fill")
            cell.imgView.backgroundColor = .clear
            cell.imgView.tintColor = .btnTealBackground
            cell.imgView.frame.size.width = 50
            cell.lblLoginGuide.textColor = .btnTealBackground
            cell.lblLoginGuide.adjustsFontSizeToFitWidth = true
            cell.lblLoginGuide.numberOfLines = 3
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarSettingCell") as? SettingCell else { return UITableViewCell() }
            if carList.isEmpty {
                cell.lblCarName.text = "등록된 차량이 없습니다."
                cell.lblCarType.text = ""
                cell.isUserInteractionEnabled = false
            } else {
                let item = carList[indexPath.row]
                let fuel = item.typeFuel == .gasoline ? "휘발유":"디젤"
                let shift = item.typeShift == .Auto ? "오토":"수동"
                cell.lblCarName.text = "[\(item.carNumber)] \(item.carName)"
                cell.lblCarType.text = "\(fuel) (\(shift))"
            }
            cell.lblCarName.sizeToFit()
            cell.lblCarType.sizeToFit()
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
            return "Car List"
        default:
            return ""
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let EditCarVC = storyboard?.instantiateViewController(withIdentifier: "AddCarViewController") as? AddAndEditCarViewController else { return }
            EditCarVC.titleForPage = "차량 정보 수정"
            EditCarVC.carInfo = carList[indexPath.row]
            EditCarVC.indexOfCar = indexPath.row
            EditCarVC.btnTitle = "수정"
            EditCarVC.delegate2 = self
            self.present(EditCarVC, animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 70
        default: return 0
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
