//
//  ItemDetailViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class ItemDetailViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var indexOfCar: Int!
    var idOfMaintenance: Int!
    var dayOfManage: Date = Date()
    var pickerDate: UIDatePicker!
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var btnRenew: UIButton!
    @IBOutlet var tfMileageCurrent: UITextField!
    @IBOutlet var tfDateCurrent: UITextField!
    
    var maintenance: Maintenance! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCollectionView()
        settingTopBackgroundView()
        settingBtnRenew()
        self.settingDatePicker()
        settingData()
        tfMileageCurrent.keyboardType = .numberPad
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func settingTopBackgroundView() {
        viewBackground.backgroundColor = .systemGray6
        viewBackground.layer.cornerRadius = 20
        // 상단 백그라운드 그림자 효과
        viewBackground.layer.shadowColor = UIColor.systemGray.cgColor
        viewBackground.layer.shadowRadius = 1.0
        viewBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewBackground.layer.shadowOpacity = 0.5
    }
    
    private func settingBtnRenew() {
        btnRenew.layer.cornerRadius = 10
        btnRenew.tintColor = .white
        btnRenew.backgroundColor = .btnTealBackground
    }
    
    private func settingCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }
    
    private func settingDatePicker() {
        pickerDate = UIDatePicker()
        pickerDate.preferredDatePickerStyle = .inline
        pickerDate.locale = Locale(identifier: "ko-KR")
        tfDateCurrent.inputView = pickerDate
        pickerDate.addTarget(self, action: #selector(selectedDay), for: .valueChanged)
        
    }
    
    @objc func selectedDay() {
        dayOfManage = pickerDate.date
        tfDateCurrent.text = Funcs.formatteredDate(date: dayOfManage)
    }
    
    private func settingData() {
        if let index = indexOfCar {
            let carInfo = appDelegate.carList[index]
            tfMileageCurrent.text = "\(carInfo.mileage)"
        } else {
            tfMileageCurrent.placeholder = "00"
        }
        tfDateCurrent.text = Funcs.formatteredDate(date: Date())
    }
    
    @IBAction func tapBtnRenewMileage(_ sender: UIButton) {
        if appDelegate.carList.count < 1 {
            let emptyAlert = UIAlertController(title: "등록된 차량이 없습니다.", message: "차량 등록 후 이용해 주세요.", preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "확인", style: .default))
            present(emptyAlert, animated: true)
        } else {
            let (mileage, date) = (Int(tfMileageCurrent.text ?? "0"), dayOfManage)
            let history = ManageHistory(mileage: mileage ?? 0, ChangeDate: date)
            guard let itemListVC = storyboard?.instantiateViewController(withIdentifier: "ItemListTableController") as? ItemListTableController else { return }
            itemListVC.indexOfCar = self.indexOfCar
            itemListVC.idOfItem = self.idOfMaintenance
            itemListVC.history = history
            itemListVC.isSelected[idOfMaintenance] = true
            itemListVC.delegate = self
            navigationController?.present(itemListVC, animated: true)
        }
        self.view.endEditing(true)
    }
}


extension ItemDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if maintenance?.historyManage == nil || maintenance?.historyManage.isEmpty == true {
            return 3
        } else {
            return maintenance.historyManage.count * 4
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        let bgrColor = UIColor.clear
        switch indexPath.row % 4 {
        case 0: identifier = "ItemImageCell"
        case 1: identifier = "ItemIntervalCell"
        case 2: identifier = "ItemMileageCell"
        default: identifier = "ItemDateCell"
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ItemDetailCell else { return UICollectionViewCell()}
        cell.backgroundColor = bgrColor
        
        if maintenance == nil || maintenance.historyManage.isEmpty {
            switch indexPath.row {
            case 0: cell.settingImageView(image: "arrow.up")
            case 1: cell.lblText.text = ""
            default: cell.settingLabel(text: "지난 내역이 없습니다.")
            }
        } else {
            let historyReversed = Array(self.maintenance.historyManage.reversed())
            switch indexPath.row % 4 {
            case 0: cell.settingImageView(image: "arrow.up")
            case 1:
                let standard: Int = indexPath.row == 1 ? (Int(tfMileageCurrent.text ?? "0") ?? 0) : historyReversed[(indexPath.row / 4) - 1].mileage
                let gapMileage = standard - historyReversed[(indexPath.row / 4)].mileage
                cell.settingLabel(text: "\(gapMileage)")
                cell.lblText.textColor = .secondaryLabel
                cell.lblText.font = .systemFont(ofSize: 14)
            case 2:
                let text = historyReversed[indexPath.row / 4].mileage
                cell.settingLabel(text: "\(text)")
                cell.backgroundColor = .systemTeal.withAlphaComponent(0.5)
                cell.layer.cornerRadius = 10
            default:
//                let standard: Date = indexPath.row == 3 ? dayOfManage: historyReversed[(indexPath.row / 4) - 1].ChangeDate
//                let gapDay = standard.timeIntervalSince(historyReversed[indexPath.row / 4].ChangeDate) / ( 3600 * 24 )
                let changeDate = Funcs.formatteredDate(date: historyReversed[indexPath.row / 4].ChangeDate)
                cell.settingLabel(text: "\(changeDate)")
                cell.lblText.textColor = .secondaryLabel
                cell.lblText.font = .systemFont(ofSize: 14)
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
    
}
