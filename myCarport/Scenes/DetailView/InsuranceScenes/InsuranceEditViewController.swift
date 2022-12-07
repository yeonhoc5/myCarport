//
//  InsuranceEditViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

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
    var insurance: Insurance?
    var indexOfCar: Int!
//    let pickerCorp = UIPickerView()
    let pickerDate = UIDatePicker()
    var titleInsurance: String = "보험 수정"
    var titleRegistBtn: String = "등록"
    let nameOfCorps = ["AXA손해보험", "DB손해보험","KB손해보험", "MG손해보험","롯데손해보험","메리츠화재","삼성화재", "캐롯손해보험","하나손해보험","한화손해보험","현대해상","흥국화재"]
    let logoOfCorps = ["axa", "db","kb", "mg","lotte","meritz","samsung", "carrot","hana","hanhwa","hyundai","heungkuk"]
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
        settingDatePicker()
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
    
    func settingBtns() {
        btnRegist.setTitle(titleRegistBtn, for: .normal)
        [btnRegist, btnCancel].forEach {
            $0?.layer.cornerRadius = 10
            $0?.backgroundColor = .btnTealBackground
            $0?.tintColor = .white
        }
        btnRegist.isEnabled = false
    }

    func settingTfs() {
        [tfNameOfCorp, tfDateStart, tfDateEnd].forEach {
            $0?.delegate = self
            $0?.tintColor = .clear
        }
        [tfMileage, tfPay].forEach {
            $0?.keyboardType = .numberPad
            $0?.textAlignment = .center
        }
//        pickerCorp.delegate = self
//        pickerCorp.dataSource = self
//        tfNameOfCorp.inputView = pickerCorp
        tfNameOfCorp.inputView = UIView()
        tfNameOfCorp.addTarget(self, action: #selector(showCollectionView), for: .allTouchEvents)
        tfNameOfCorp.addTarget(self, action: #selector(checkEmpty), for: .editingChanged)
        tfNameOfCorp.textColor = .label
    }
    @objc func showCollectionView() {
        UIView.animate(withDuration: 0.4) {
            self.collectionView.layer.opacity = 1
        }
    }
    @objc func checkEmpty() {
        Funcs.checkValidation(textFields: [tfNameOfCorp], btn: btnRegist)
    }
    func settingStartData() {
        lblTitleInsurance.text = titleInsurance
        if insurance == nil {
            startDate = Date()
            endDate = startDate.addingTimeInterval(364 * 24 * 3600)
            tfNameOfCorp.placeholder = "보험사를 선택해 주세요"
            tfMileage.text = "0"
            tfPay.text = "0"
        } else {
            startDate = insurance?.dateStart
            endDate = insurance?.dateEnd
            tfNameOfCorp.placeholder = insurance?.corpName
            tfMileage.text = "\(insurance?.startMileage ?? 0)"
            tfPay.text = "\(insurance?.payContract ?? 0)"
        }
        tfDateStart.text = Funcs.formatteredDate(date: startDate)
        tfDateEnd.text = Funcs.formatteredDate(date: endDate)
    }
    func settingDatePicker() {
        [tfDateStart, tfDateEnd].forEach {
            $0?.inputView = pickerDate
        }
        pickerDate.preferredDatePickerStyle = .inline
        pickerDate.locale = Locale(identifier: "ko-KR")
        pickerDate.addTarget(self, action: #selector(selectedDay), for: .valueChanged)
    }
    @objc func selectedDay() {
        startDate = pickerDate.date
        endDate = startDate.addingTimeInterval(364 * 24 * 3600)
        tfDateStart.text = Funcs.formatteredDate(date: startDate)
        tfDateEnd.text = Funcs.formatteredDate(date: endDate)
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
        mileage = Int(tfMileage.text ?? "0")
        pay = Int(tfPay.text ?? "0")
        let insurance = Insurance(corpName: nameOfCorps[selectedRow], dateStart: startDate, dateEnd: endDate, payContract: pay ?? 0, startMileage: mileage ?? 0)
        appDelegate.carList[indexOfCar].insurance.append(insurance)
        self.dismiss(animated: true)
        delegate.navigationController?.popToRootViewController(animated: true)
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
        return nameOfCorps.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CorpNameCell", for: indexPath) as? CorpNameCell else { return UICollectionViewCell()}
        cell.settingCell(image: logoOfCorps[indexPath.row])
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
        tfNameOfCorp.text = nameOfCorps[indexPath.row]
        tfNameOfCorp.sendActions(for: .editingChanged)
        selectedRow = indexPath.row
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.collectionView.layer.opacity = 0
        }
    }
    
    
    
}
