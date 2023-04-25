//
//  AddAndEditCarViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class AddAndEditCarViewController: UIViewController {
    // MARK: - 1. outlets & properties
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnRegist: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    @IBOutlet var tfCarName: UITextField!
    @IBOutlet var tfCarNumber: UITextField!
    @IBOutlet var sgmCarFuel: UISegmentedControl!
    @IBOutlet var sgmCarType: UISegmentedControl!
    @IBOutlet var tfMileage: UITextField!
    
    var titleForPage = "차량 등록"
    var btnTitle = "등록"
    var carInfo: CarInfo? 
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var sgmIndexFule: Int!
    var sgmIndexType: Int!
    var textfields: [UITextField]!
    
    var delegate: HomeViewController!
    var delegate2: SettingViewController!
    
    lazy var dao = CarInfoDAO()
    
    //MARK: - 2. view DidLoad & touchsBegan
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
        settingTextFields()
        settingData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: - 3.버튼 Tab actions
    @IBAction func tapBtnRegist(_ sender: UIButton) {
        // 등록 화면
        if carInfo == nil {
            guard let carNameToAdd: String = tfCarName?.text,
                  let carNumbToAdd: String = tfCarNumber?.text,
                  let mileageToAdd: Int = Int((tfMileage?.text == "" ? "0" : tfMileage.text)!) else { return }
            let carInfo = CarInfo(carName: carNameToAdd,
                                  carNumber: carNumbToAdd,
                                  typeFuel: Int16(sgmCarFuel.selectedSegmentIndex).toTypeFuel(),
                                  typeShift: Int16(sgmCarType.selectedSegmentIndex).toTypeShift(),
                                  mileage: mileageToAdd)
            if dao.addCarList(carInfo) {
                if let count = appDelegate.myCarList.last?.maintenance.count {
                    delegate.addAnimationCount(count: count + 1)
                }
            }
        } else {
        // 수정 화면
            guard let carNameToEdit: String = tfCarName?.text == "" ? tfCarName.placeholder : tfCarName?.text,
                  let carNumbToEdit: String = tfCarNumber?.text == "" ? tfCarNumber.placeholder : tfCarNumber.placeholder,
                  let mileageToEdit: Int = Int(tfMileage?.text == "" ? tfMileage.placeholder! : tfMileage.text ?? "0") else { return }
            let typeFueltoEdit: TypeFuel = sgmCarFuel.selectedSegmentIndex == 0 ? .gasoline : .diesel
            let typeShiftToEdit: TypeShift = sgmCarType.selectedSegmentIndex == 0 ? .auto : .manual
            
            print(carNameToEdit, carNumbToEdit, mileageToEdit, typeFueltoEdit, typeShiftToEdit)
            let modifiedCarInfo = CarInfo(carName: carNameToEdit, carNumber: carNumbToEdit, typeFuel: typeFueltoEdit, typeShift: typeShiftToEdit, mileage: mileageToEdit)
            
            if let carID = carInfo?.objectID {
                let dao = CarInfoDAO()
                if dao.modifyCarInfo(carID: carID, carInfo: modifiedCarInfo) {
                    appDelegate.myCarList = dao.fetch()
                    delegate2.renewCarList()
                }
            }
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func tapBtnCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}

// MARK: - 4. [extension] 뷰 초기 세팅
extension AddAndEditCarViewController {
    // 뷰 기본 세팅
    func settingView() {
        lblTitle.text = titleForPage
        tfCarName.becomeFirstResponder()
        // 버튼 설정
        [btnRegist, btnCancel].forEach {
            $0?.layer.cornerRadius = 10
            $0?.backgroundColor = .systemTeal.withAlphaComponent(0.8)
            $0?.tintColor = .white
        }
        btnRegist.setTitle(btnTitle, for: .normal)
        btnRegist.isEnabled = false
    }
    // 텍스트 필드 설정
    func settingTextFields() {
        tfMileage.keyboardType = .numberPad
        textfields = [tfCarName, tfCarNumber, tfMileage]
        textfields.forEach  {
            $0.addTarget(self, action: #selector(checkEmpty), for: .editingChanged)
        }
        [sgmCarFuel, sgmCarType].forEach {
            $0?.addTarget(self, action: #selector(checkChange), for: .valueChanged)
        }
    }
    @objc func checkEmpty() {
        if carInfo == nil {
            Funcs.checkValidation(textFields: [tfCarName, tfCarNumber], btn: btnRegist)
        } else {
            Funcs.checkValidation(textFields: [tfCarName, tfCarNumber, tfMileage], btn: btnRegist, type: .any)
        }
    }
    @objc func checkChange() {
        if carInfo != nil {
            if (sgmCarFuel.selectedSegmentIndex != carInfo?.typeFuel.rawValue ?? 0
                || sgmCarType.selectedSegmentIndex != carInfo?.typeShift.rawValue ?? 0) {
                self.btnRegist.isEnabled = true
            } else {
                self.btnRegist.isEnabled = false
            }
        }
    }
    
    // 초기 데이터 설정
    private func settingData() {
        if let carSelected = carInfo {
            tfCarName.placeholder = carSelected.carName
            tfCarNumber.placeholder = carSelected.carNumber
            sgmCarFuel.selectedSegmentIndex = carSelected.typeFuel == .gasoline ? 0:1
            sgmCarType.selectedSegmentIndex = carSelected.typeShift == .auto ? 0:1
            tfMileage.placeholder = "\(carSelected.mileage)"
        } else {
            tfCarName.placeholder = "차량명을 입력해주세요."
            tfCarNumber.placeholder = "차대번호를 입력해주세요."
            tfMileage.placeholder = "0"
        }
    }
    
}
