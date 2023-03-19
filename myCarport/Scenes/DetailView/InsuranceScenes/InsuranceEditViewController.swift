//
//  InsuranceEditViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

protocol EditInsurance {
    func editInsurance(type: EditType, index: Int!, insurance: Insurance)
}
        
class InsuranceEditViewController: UIViewController {

    // 아울렛 properties
    @IBOutlet var lblTitleInsurance: UILabel!
    @IBOutlet var tfDateStart: UITextField!
    @IBOutlet var tfDateEnd: UITextField!
    @IBOutlet var tfNameOfCorp: UITextField!
    @IBOutlet var tfMileage: UITextField!
    @IBOutlet var tfPay: UITextField!
    @IBOutlet var btnRegist: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    // 뷰 세팅용 properties
    var carInfo: CarInfo?
    var insurance: Insurance?
    var indexOfInsurance: Int!
    let pickerDateSE = UIDatePicker()
    let pickerDateE = UIDatePicker()
    var titleInsurance: String = "보험 수정"
    var titleRegistBtn: String = "등록"
    // 저장할 데이터용 properties
    var selectedRow: Int!
    var startDate: Date!
    var endDate: Date!
    var mileage: Int!
    var pay: Int!
    //
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var delegate: InsuranceDetailViewController!
    
    
    //MARK: - [View Did Load] & [touches Bega]
    override func viewDidLoad() {
        super.viewDidLoad()
        settingBtns()
        settingTfs()
        settingStartData()
        settingDatePickers()
        settingCollectionView()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.4) {
            self.collectionView.layer.opacity = 0
        }
    }
    // 콜렉션뷰 높이 자동 조정
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height + collectionView.contentInset.top + collectionView.contentInset.bottom
        self.view.layoutIfNeeded()
    }
    // 버튼 세팅
    func settingBtns() {
        btnRegist.setTitle(titleRegistBtn, for: .normal)
        [btnRegist, btnCancel].forEach {
            $0?.layer.cornerRadius = 10
            $0?.backgroundColor = .btnTealBackground
            $0?.tintColor = .white
        }
        if insurance != nil {
            if tfNameOfCorp.text != ""
                || tfDateStart.text != ""
                || tfDateEnd.text != ""
                || tfPay.text != ""
                || tfMileage.text != "" {
                btnRegist.isEnabled = true
            } else {
                btnRegist.isEnabled = false
            }
        } else {
            btnRegist.isEnabled = false
        }

    }
    // 텍스트필드 세팅
    func settingTfs() {
        [tfNameOfCorp, tfDateStart, tfDateEnd].forEach {
            $0?.delegate = self
            $0?.tintColor = .clear
        }
        [tfMileage, tfPay].forEach {
            $0?.keyboardType = .numberPad
            $0?.textAlignment = .center
        }
        tfNameOfCorp.inputView = UIView()
        tfNameOfCorp.addTarget(self, action: #selector(showCollectionView), for: .allTouchEvents)
        [tfNameOfCorp, tfPay, tfMileage, tfDateStart, tfDateEnd].forEach {
            $0.addTarget(self, action: #selector(checkEmpty), for: .editingChanged)
        }
//        pickerDate.sendActions(for: .valueChanged)
        tfNameOfCorp.textColor = .label
    }
    @objc func showCollectionView() {
        UIView.animate(withDuration: 0.4) {
            self.collectionView.layer.opacity = 1
        }
    }
    @objc func checkEmpty() {
        if insurance == nil {
            Funcs.checkValidation(textFields: [tfNameOfCorp], btn: btnRegist)
        } else {
            Funcs.checkValidation(textFields: [tfNameOfCorp, tfDateStart, tfDateEnd, tfPay, tfMileage], btn: btnRegist, type: .any)
        }
    }
    func settingStartData() {
        lblTitleInsurance.text = titleInsurance
        if insurance == nil {
            startDate = Date()
            endDate = startDate.addingTimeInterval(364 * 24 * 3600)
            tfNameOfCorp.placeholder = "보험사를 선택해 주세요"
            tfMileage.placeholder = "0"
            tfPay.placeholder = "0"
            tfDateStart.text = Funcs.formatteredDate(date: startDate)
            tfDateEnd.text = Funcs.formatteredDate(date: endDate)
        } else {
            startDate = insurance?.dateStart
            endDate = insurance?.dateEnd
            tfNameOfCorp.placeholder = insurance?.corpName
            tfMileage.placeholder = "\(insurance?.mileageContract ?? 0)"
            tfPay.placeholder = "\(insurance?.payContract ?? 0)"
            tfDateStart.placeholder = Funcs.formatteredDate(date: startDate)
            tfDateEnd.placeholder = Funcs.formatteredDate(date: endDate)
            selectedRow = appDelegate.insuranceCorp.firstIndex(where: { $0.name == insurance?.corpName })
             
        }
    }
    
    func settingDatePickers() {
        [pickerDateSE, pickerDateE].forEach {
            $0.preferredDatePickerStyle = .inline
            $0.locale = Locale(identifier: "ko-KR")
        }
        pickerDateSE.addTarget(self, action: #selector(selectedDay), for: .valueChanged)
        pickerDateE.addTarget(self, action: #selector(changeEndDay), for: .valueChanged)

        if insurance != nil {
            pickerDateSE.setDate(insurance?.dateStart ?? Date(), animated: false)
            pickerDateE.setDate(insurance?.dateEnd ?? Date(), animated: false)
        }

        
        let toolbarSE = UIToolbar()
        let toolbarE = UIToolbar()
        [toolbarSE, toolbarE].forEach {
            $0.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
            $0.backgroundColor = UIColor(red: 66/255, green: 65/255, blue: 78/255, alpha: 1)
        }
        
        let messageSE = UIBarButtonItem(title: "(시작일/종료일을 함께 변경합니다)")
        let messageE = UIBarButtonItem(title: "(종료일만 변경합니다)")
        [messageSE, messageE].forEach {
            $0.isEnabled = false
            $0.tintColor = .black
        }
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let btnDoneSE = UIBarButtonItem(title: "선택 완료", style: .done, target: self, action: #selector(closeDatePicker))
        let btnDoneE = UIBarButtonItem(title: "선택 완료", style: .done, target: self, action: #selector(closeDatePicker))
        
        toolbarSE.setItems([messageSE, spacer, btnDoneSE], animated: true)
        toolbarE.setItems([messageE, spacer, btnDoneE], animated: true)
        
        tfDateStart.inputView = pickerDateSE
        tfDateStart.inputAccessoryView = toolbarSE
        tfDateEnd.inputView = pickerDateE
        tfDateEnd.inputAccessoryView = toolbarE
        
        [pickerDateSE, pickerDateE, toolbarSE, toolbarE].forEach {
            $0.tintColor = .systemTeal
        }
    }
    
    @objc func selectedDay() {
        startDate = pickerDateSE.date
        endDate = startDate.addingTimeInterval(364 * 24 * 3600)
        tfDateStart.text = Funcs.formatteredDate(date: startDate)
        tfDateStart.sendActions(for: .editingChanged)
        tfDateEnd.text = Funcs.formatteredDate(date: endDate)
        tfDateEnd.sendActions(for: .editingChanged)
    }
    @objc func changeEndDay() {
        endDate = pickerDateE.date
        tfDateEnd.text = Funcs.formatteredDate(date: endDate)
        tfDateEnd.sendActions(for: .editingChanged)
    }
    
    @objc func closeDatePicker() {
        view.endEditing(true)
    }
    func settingCollectionView() {
        // 콜렉션뷰 델리게이트
        collectionView.dataSource = self
        collectionView.delegate = self
        // 기본 레이아웃
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.backgroundColor = .systemBackground
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        // 초기 투명도 0 설정
        collectionView.layer.opacity = 0
        // 그림자 설정
        collectionView.layer.shadowColor = UIColor.gray.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 0)
        collectionView.layer.shadowRadius = 3
        collectionView.layer.shadowOpacity = 0.8
        collectionView.layer.masksToBounds = false
    }
    
    @IBAction func tabBtnRegist(_ sender: UIButton) {
        pay = Int((tfPay.text == "" ? tfPay.placeholder : tfPay.text) ?? "0")
        mileage = Int((tfMileage.text == "" ? tfMileage.placeholder : tfMileage.text) ?? "0")
        let editedStarDate = startDate ?? insurance?.dateStart
        let editedEndDate = endDate ?? insurance?.dateEnd
        let readyInsurance = Insurance(corpName: appDelegate.insuranceCorp[selectedRow].name,
                                       dateStart: editedStarDate,
                                       dateEnd: editedEndDate,
                                       payContract: pay ?? 0,
                                       mileageContract: mileage ?? 0)
        let dao = CarInfoDAO()
        if insurance == nil {
            if let carInfo = self.carInfo {
                if dao.addInsuranceTotheCar(carInfo, insurance: readyInsurance) {
                    delegate.editInsurance(type: .add, insurance: readyInsurance)
                }
            }
        } else {
            print("step1. will change")
            if let insuranceID = self.insurance?.objectID {
                print("step2. will change")
                if dao.modifyInsuranceInfo(InsuranceID: insuranceID, insurance: readyInsurance) {
                    print("step3. will change")
                    delegate.editInsurance(type: .modify, index: indexOfInsurance, insurance: readyInsurance)
                }
            }
            
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func tabBtnCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension InsuranceEditViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return nameOfCorps.count
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return nameOfCorps[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        tfNameOfCorp.text = nameOfCorps[row]
//        selectedRow = row
//        tfNameOfCorp.sendActions(for: .editingChanged)
//    }
//}

extension InsuranceEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}



extension InsuranceEditViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.insuranceCorp.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CorpNameCell", for: indexPath) as? CorpNameCell else { return UICollectionViewCell()}
        cell.settingCell(image: appDelegate.insuranceCorp[indexPath.row].logo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 50) / 2, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tfNameOfCorp.text = appDelegate.insuranceCorp[indexPath.row].name
        tfNameOfCorp.sendActions(for: .editingChanged)
        selectedRow = indexPath.row
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.collectionView.layer.opacity = 0
        }
    }
    
    
    
}
