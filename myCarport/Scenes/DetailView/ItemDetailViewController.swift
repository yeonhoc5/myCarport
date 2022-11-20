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
    var item: Maintenance!
    
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
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 40, bottom: 0, right: 40)
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
        return 30
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        let textOrImage: String
        let bgrColor = UIColor.orange
        switch indexPath.row % 4 {
        case 0:
            identifier = "ItemMileageCell"
            textOrImage = "마일리지"
        case 1: identifier = "ItemDateCell"
            textOrImage = "2022-11-20"
        case 2: identifier = "ItemImageCell"
            textOrImage = "arrow.up"
        default: identifier = "ItemIntervalCell"
            textOrImage = "1만(1y)"
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ItemDetailCell else { return UICollectionViewCell()}
        
        switch indexPath.row % 4 {
        case 0:
            cell.lblText.text = textOrImage
            cell.backgroundColor = .systemTeal.withAlphaComponent(0.5)
            cell.layer.cornerRadius = 10
        case 1:
            cell.lblText.text = textOrImage
            cell.backgroundColor = bgrColor
        case 2:
            cell.imgView.image = UIImage(systemName: "arrow.up")?.withTintColor(.systemTeal.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
            cell.backgroundColor = bgrColor
        default:
//            cell.settingLabel()
            cell.lblText.text = textOrImage
            cell.backgroundColor = bgrColor
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
