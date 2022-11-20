//
//  AddCarViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class AddCarViewController: UIViewController {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnRegist: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    @IBOutlet var tfCarName: UITextField!
    @IBOutlet var sgmCarFuel: UISegmentedControl!
    @IBOutlet var sgmCarType: UISegmentedControl!
    @IBOutlet var tfMileage: UITextField!
    
    var titleForPage = "차량 등록"
    var btnTitle = "등록"
    var carInfo: CarInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingBtns()
        lblTitle.text = titleForPage
        if let carSelected = carInfo {
            tfCarName.placeholder = carSelected.carName
            sgmCarFuel.selectedSegmentIndex = carSelected.typeFuel == .gasoline ? 0:1
            sgmCarType.selectedSegmentIndex = carSelected.typeShift == .Auto ? 0:1
            tfMileage.placeholder = "\(carSelected.mileage)"
        }
        
        tfCarName.layer.borderColor = UIColor.black.cgColor
        btnRegist.setTitle(btnTitle, for: .normal)
        
        tfCarName.becomeFirstResponder()
    }
    
    
    func settingBtns() {
        [btnRegist, btnCancel].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.borderColor = UIColor.systemTeal.cgColor
            $0?.layer.borderWidth = 0.8
            $0?.backgroundColor = .systemTeal
            $0?.tintColor = .white
        }
    }
    
    
    @IBAction func tapBtnRegist(_ sender: UIButton) {
        
        self.dismiss(animated: true)
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
