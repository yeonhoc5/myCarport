//
//  ItemDetailViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet var viewBackground: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var btnRenew: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTopBackgroundView()
        settingBtnRenew()
        settingCollectionView()
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
    }
    
    private func settingCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 30, bottom: 0, right: 30)
        collectionView.largeContentTitle = "교체 내역"
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


extension ItemDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 26
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row % 3 {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemMileageCell", for: indexPath) as?  ItemDetailCell else { return UICollectionViewCell() }
            cell.lblText.text = "마일리지"
            cell.backgroundColor = .systemTeal.withAlphaComponent(0.5)
            cell.layer.cornerRadius = 10
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDateCell", for: indexPath) as?  ItemDetailCell else { return UICollectionViewCell() }
            cell.lblText.text = "2022-11-20"
            cell.backgroundColor = .clear
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemIntervalCell", for: indexPath) as?  ItemDetailCell else { return UICollectionViewCell() }
            cell.imgView.image = UIImage(systemName: "arrow.up")?.withTintColor(.systemTeal.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
//            cell.imgView.layer.setAffineTransform(CGAffineTransform(rotationAngle: -0.4))
            cell.lblText.text = "1만(1y)"
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row % 3 {
        case 2: return CGSize(width: UIScreen.main.bounds.width, height: 40)
        default: return CGSize(width: UIScreen.main.bounds.width / 2 - 65, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
