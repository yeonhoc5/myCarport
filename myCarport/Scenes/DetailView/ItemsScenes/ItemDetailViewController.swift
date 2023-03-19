//
//  ItemDetailViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController {
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var lblMaintenanceTitle: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var btnRenew: UIButton!
    @IBOutlet var tfMileageCurrent: UITextField!
    @IBOutlet var tfDateCurrent: UITextField!
    @IBOutlet var viewForlblOrderInfo: UIView!
    
    var carInfo: CarInfo?
    var navigationtitle: String = ""
    var itemTitle: String = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var indexOfCar: Int!
    var idOfMaintenance: Int!
    var dayOfManage: Date = Date()
    var pickerDate: UIDatePicker!
    
    var isEditMode: Bool = false
    var alertTextField: UITextField?
    
    var maintenance: Maintenance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingData()
        
        settingCollectionView()
        settingTopBackgroundView()
        settingNavigationBar()
        settingDatePicker()
        
        tfMileageCurrent.keyboardType = .numberPad
        settingOrderInfo()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
//        self.presentedViewController?.dismiss(animated: true)
    }

    private func settingCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }
    
    private func settingTopBackgroundView() {
        viewBackground.backgroundColor = .systemGray6
        viewBackground.layer.cornerRadius = 20
        // 상단 백그라운드 그림자 효과
        viewBackground.layer.shadowColor = UIColor.systemGray.cgColor
        viewBackground.layer.shadowRadius = 1.0
        viewBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewBackground.layer.shadowOpacity = 0.5
        lblMaintenanceTitle.text = itemTitle
        lblMaintenanceTitle.sizeToFit()
    }
    
    private func settingNavigationBar() {
        self.navigationItem.title = navigationtitle
        btnRenew.layer.cornerRadius = 10
        btnRenew.tintColor = .white
        btnRenew.backgroundColor = .systemTeal.withAlphaComponent(0.8)
        btnRenew.becomeFirstResponder()
    }
    
    private func settingDatePicker() {
        pickerDate = UIDatePicker()
        pickerDate.preferredDatePickerStyle = .inline
        pickerDate.locale = Locale(identifier: "ko-KR")
        tfDateCurrent.inputView = pickerDate
        alertTextField?.inputView = pickerDate
        pickerDate.addTarget(self, action: #selector(selectedDay), for: .valueChanged)
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        toolbar.backgroundColor = UIColor(red: 66/255, green: 65/255, blue: 78/255, alpha: 1)
        let btnDone = UIBarButtonItem(title: "선택 완료", style: .done, target: self, action: #selector(closeDatePicker))
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        
        toolbar.setItems([spacer, btnDone], animated: true)
        toolbar.tintColor = .systemTeal
        
        tfDateCurrent.inputAccessoryView = toolbar
        alertTextField?.inputAccessoryView = toolbar
        pickerDate.tintColor = .systemTeal
    }
    @objc func selectedDay() {
        dayOfManage = pickerDate.date
        if !isEditMode {
            tfDateCurrent.text = Funcs.formatteredDate(date: dayOfManage)
        } else {
            alertTextField?.text = Funcs.formatteredDate(date: dayOfManage)
        }
    }
    @objc func closeDatePicker() {
        view.endEditing(true)
    }
    private func settingData() {
        if let carInfo = self.carInfo {
            tfMileageCurrent.placeholder = String(carInfo.mileage)
        } else {
            tfMileageCurrent.placeholder = "\(appDelegate.sampleCar.mileage)"
        }
        tfDateCurrent.text = Funcs.formatteredDate(date: Date())
    }
    func settingOrderInfo() {
        viewForlblOrderInfo.backgroundColor = .systemGray6
        viewForlblOrderInfo.layer.cornerRadius = 15
        viewForlblOrderInfo.layer.shadowColor = UIColor.systemGray.cgColor
        viewForlblOrderInfo.layer.shadowRadius = 2
        viewForlblOrderInfo.layer.shadowOpacity = 0.5
        viewForlblOrderInfo.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewForlblOrderInfo.layer.masksToBounds = false
        
    }
    @IBAction func tapBtnRenewMileage(_ sender: UIButton) {
        self.view.endEditing(true)
        if carInfo == nil {
            let emptyAlert = UIAlertController(title: "등록된 차량이 없습니다.", message: "차량 등록 후 이용해 주세요.", preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "확인", style: .default))
            present(emptyAlert, animated: true)
        } else {
            let mileage = Int((tfMileageCurrent.text == "" ? tfMileageCurrent.placeholder : tfMileageCurrent.text) ?? "0")
            let history = ManageHistory(mileage: mileage ?? 0, changeDate: dayOfManage)
            guard let itemListVC = storyboard?.instantiateViewController(withIdentifier: "ItemListTableController") as? ItemListTableController else { return }
            itemListVC.maintenance = carInfo?.maintenance
            if let maintenanceID = maintenance?.objectID {
                itemListVC.selectedID = [maintenanceID]
                itemListVC.history = history
                itemListVC.delegate = self
                navigationController?.present(itemListVC, animated: true)
            }
        }
    }
}


extension ItemDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let history = maintenance == nil ? appDelegate.sampleHistory : maintenance?.historyManage
        return history?.count == 0 ? 3 : ((history?.count ?? 1) * 4 + 4)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        let bgrColor = UIColor.clear
        
        
        let history = maintenance == nil ? appDelegate.sampleHistory : maintenance?.historyManage
        
        if history?.count == 0 {
            switch indexPath.row {
            case 0: identifier = "ItemImageCell"
            case 1: identifier = "ItemIntervalCell"
            case 2: identifier = "ItemMileageCell"
            default: identifier = "ItemDateCell"
            }
        }  else {
            if indexPath.row / 4 <= (history?.count)! - 1 {
                switch indexPath.row % 4 {
                case 0: identifier = "ItemImageCell"
                case 1: identifier = "ItemIntervalCell"
                case 2: identifier = "ItemMileageCell"
                default: identifier = "ItemDateCell"
                }
            } else {
                identifier = "ItemIntervalCell"
            }
            
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ItemDetailCell else { return UICollectionViewCell()}
        cell.backgroundColor = bgrColor
        
        if let history = maintenance == nil ? appDelegate.sampleHistory : maintenance?.historyManage {
            if history.isEmpty {
                switch indexPath.row % 4 {
                case 0: cell.settingSubLabel(text: "", image: "")
                case 2: cell.settingLabel(text: "지난 내역이 없습니다.")
                default: break
                }
            } else {
                if indexPath.row / 4 <= (history.count) - 1 {
                    let historyReversed = Array(history.reversed())
                    switch indexPath.row % 4 {
                    case 0:
                        let standard: Int = indexPath.row == 0 ? (Int(tfMileageCurrent.placeholder ?? "0") ?? 0) : historyReversed[(indexPath.row / 4) - 1].mileage
                        let gapMileage = standard - historyReversed[(indexPath.row / 4)].mileage
                        cell.settingSubLabel(text: "\(Funcs.addCommaToNumber(number: gapMileage)) km", image: "arrow.up")
                        cell.lblSubText.textColor = .secondaryLabel
                        cell.lblSubText.font = .systemFont(ofSize: 14)
                    case 2:
                        let text = historyReversed[indexPath.row / 4].mileage
                        cell.settingLabel(text: "\(Funcs.addCommaToNumber(number: text))")
                        cell.backgroundColor = .systemTeal.withAlphaComponent(0.5)
                        cell.layer.cornerRadius = 10
                    case 3:
        //                let standard: Date = indexPath.row == 3 ? dayOfManage: historyReversed[(indexPath.row / 4) - 1].ChangeDate
        //                let gapDay = standard.timeIntervalSince(historyReversed[indexPath.row / 4].ChangeDate) / ( 3600 * 24 )
                        let changeDate = Funcs.formatteredDate(date: historyReversed[indexPath.row / 4].changeDate)
                        cell.settingLabel(text: "\(changeDate)")
                        cell.lblText.textColor = .secondaryLabel
                        cell.lblText.font = .systemFont(ofSize: 14)
                    default:
                        break
                    }
                } else {
                    
                }
                
            }
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionView.frame.width - 90) / 5
        return CGSize(width: indexPath.row % 2 == 0 ? size * 3:size * 2, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if maintenance?.historyManage.count ?? 0 > 0 {
            if indexPath.row % 4 == 2 {
                self.isEditMode = true
                let reversedHistory = self.maintenance?.historyManage.reversed()
                let history = Array(reversedHistory!)[indexPath.row / 4]
                let alert = UIAlertController(title: "관리 이력 수정", message: "", preferredStyle: .alert)
                alert.addTextField {
                    $0.placeholder = String(history.mileage)
                    $0.textAlignment = .center
                    $0.keyboardType = .numberPad
                }
                alert.addTextField {
                    $0.placeholder = String(Funcs.formatteredDate(date: history.changeDate))
                    $0.textAlignment = .center
                    self.alertTextField = $0
                    $0.inputView = self.pickerDate
                    let toolbar = UIToolbar()
                    toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
                    toolbar.backgroundColor = UIColor(red: 66/255, green: 65/255, blue: 78/255, alpha: 1)
                    let btnDone = UIBarButtonItem(title: "선택 완료", style: .done, target: self, action: #selector(self.closeDatePicker))
                    let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
                    
                    toolbar.setItems([spacer, btnDone], animated: true)
                    toolbar.tintColor = .systemTeal
                    
                    $0.inputAccessoryView = toolbar
                }
                
                alert.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
                    let mile = Int((alert.textFields?[0].text == "" ? alert.textFields?[0].placeholder : alert.textFields?[0].text)!)!
                    
                    let date = alert.textFields?[1].text == "" ? history.changeDate : self.dayOfManage
            
                    let modifiedHistory = ManageHistory(mileage: mile, changeDate: date)
                    let dao = CarInfoDAO()
                    if let historyID = history.objectID {
                        if dao.modifyHistory(historyID: historyID, history: modifiedHistory) {
                            self.maintenance?.historyManage[(reversedHistory?.count)! - ((indexPath.row / 4) + 1)].mileage = mile
                            self.maintenance?.historyManage[(reversedHistory?.count)! - ((indexPath.row / 4) + 1)].changeDate = date
                            if let history = self.maintenance?.historyManage {
                                self.maintenance?.historyManage = history.sorted(by: {$0.changeDate < $1.changeDate})
                            }
                            self.collectionView.reloadData()
                            self.isEditMode = false
                        }
                    } else {
                        let appDelgate = UIApplication.shared.delegate as! AppDelegate
                        let maintenanceData = appDelgate.myCarList.filter({$0.objectID == self.carInfo?.objectID}).first?.maintenance
                        if let historyData = maintenanceData?.filter({$0.objectID == self.maintenance?.objectID}).first?.historyManage,
                           let objectIDToEdit = historyData[historyData.count - (indexPath.row / 4) - 1].objectID {
                            if dao.modifyHistory(historyID: objectIDToEdit, history: modifiedHistory) {
                                self.maintenance?.historyManage[(reversedHistory?.count)! - ((indexPath.row / 4) + 1)].mileage = mile
                                self.maintenance?.historyManage[(reversedHistory?.count)! - ((indexPath.row / 4) + 1)].changeDate = date
                                if let history = self.maintenance?.historyManage {
                                    self.maintenance?.historyManage = history.sorted(by: {$0.changeDate < $1.changeDate})
                                }
                                self.collectionView.reloadData()
                                self.isEditMode = false
                            }
                        }
                        
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                    let dao = CarInfoDAO()
                    if let historyID = history.objectID {
                        if dao.deleteData(id: historyID) {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.myCarList = dao.fetch()
                            self.maintenance?.historyManage.remove(at: (reversedHistory?.count)! - ((indexPath.row / 4) + 1))
                            self.collectionView.reloadData()
                        }
                    }
                    self.isEditMode = false
                    self.dismiss(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {_ in
                    self.isEditMode = false
                    self.dismiss(animated: true)
                    
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
}


extension ItemDetailViewController: AddHistory {

    func addHistory(_ history: ManageHistory) {
        self.maintenance?.historyManage.append(history)
        if let history = self.maintenance?.historyManage {
            self.maintenance?.historyManage = history.sorted(by: {$0.changeDate < $1.changeDate})
        }
        self.collectionView.reloadData()
        self.tfMileageCurrent.text = ""
        self.settingData()
    }
    
}
