//
//  AddAndEditCarViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class AddAndEditCarViewController: UIViewController {
    
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
    
    // 수정용 properties
    var indexOfCar: Int!
    
    //MARK: - view DidLoad & touchsBegan
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
        settingTextFields()
        self.settingData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingData()
    }
    
    func settingView() {
        lblTitle.text = titleForPage
        tfCarName.becomeFirstResponder()
        // setting buttons
        [btnRegist, btnCancel].forEach {
            $0?.layer.cornerRadius = 10
            $0?.backgroundColor = .btnTealBackground
            $0?.tintColor = .white
        }
        btnRegist.setTitle(btnTitle, for: .normal)
        btnRegist.isEnabled = false
        
    }
    
    func settingTextFields() {
        tfMileage.keyboardType = .numberPad
        textfields = [tfCarName, tfCarNumber, tfMileage]
        textfields.forEach  {
            $0.addTarget(self, action: #selector(checkEmpty), for: .editingChanged)
        }
    }
    @objc func checkEmpty() {
        Funcs.checkValidation(textFields: textfields, btn: btnRegist)
    }
    
    private func settingData() {
        if let carSelected = carInfo {
            tfCarName.text = carSelected.carName
            tfCarNumber.text = carSelected.carNumber
            sgmCarFuel.selectedSegmentIndex = carSelected.typeFuel == .gasoline ? 0:1
            sgmCarType.selectedSegmentIndex = carSelected.typeShift == .Auto ? 0:1
            tfMileage.text = "\(carSelected.mileage)"
        } else {
            tfCarName.placeholder = "자유롭게 입력해주세요."
            tfCarNumber.placeholder = "차대 번호를 입력해주세요."
            tfMileage.text = "0"
        }
    }
    
    @IBAction func tapBtnRegist(_ sender: UIButton) {
        if carInfo == nil {
            guard let carNameToAdd: String = tfCarName?.text,
                  let carNumbToAdd: String = tfCarNumber?.text,
                  let mileageToAdd: Int = Int(tfMileage?.text ?? "") else { return }
            appDelegate.carList.append(CarInfo(carName: carNameToAdd,
                                               carNumber: carNumbToAdd,
                                               typeFuel: sgmCarFuel.selectedSegmentIndex == 0 ? .gasoline:.diesel,
                                               typeShift: sgmCarType.selectedSegmentIndex == 0 ? .Auto:.Stick,
                                               mileage: mileageToAdd,
                                               maintenance: appDelegate.settingFirstMaintenance()))
            delegate.animationCount.append(Array(repeating: -1, count: 19))
            self.dismiss(animated: true)
        } else {
            guard let carNameToEdit: String = tfCarName?.text,
                  let carNumbToEdit: String = tfCarNumber?.text,
                  let mileageToEdit: Int = Int(tfMileage?.text ?? "") else { return }
            print(carNumbToEdit, carNumbToEdit, mileageToEdit)
            appDelegate.carList[indexOfCar].carName = carNameToEdit
            appDelegate.carList[indexOfCar].carNumber = carNumbToEdit
            appDelegate.carList[indexOfCar].mileage = mileageToEdit
            appDelegate.carList[indexOfCar].typeFuel = sgmCarFuel.selectedSegmentIndex == 0 ? .gasoline:.diesel
            appDelegate.carList[indexOfCar].typeShift = sgmCarType.selectedSegmentIndex == 0 ? .Auto:.Stick
            delegate2.carList = appDelegate.carList
            self.dismiss(animated: true)
        }
        
    }
    
    @IBAction func tapBtnCancel(_ sender: UIButton) {
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
