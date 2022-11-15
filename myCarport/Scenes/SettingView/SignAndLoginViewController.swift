//
//  SignAndLoginViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class SignAndLoginViewController: UIViewController {

    
    @IBOutlet var btnGoogle: UIButton!
    @IBOutlet var btnApple: UIButton!
    @IBOutlet var btnIdAandPass: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingBtns()
    }
    
    func settingBtns() {
        [btnGoogle, btnApple, btnIdAandPass].forEach {
            $0?.backgroundColor = .systemTeal
            $0?.tintColor = .white
            $0?.layer.cornerRadius = 20
            $0?.clipsToBounds = true
        }
        btnCancel.tintColor = .systemTeal
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
