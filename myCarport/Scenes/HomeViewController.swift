//
//  HomeViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/01.
//

import UIKit

class HomeViewController: UIViewController {

    var myCarList: [CarInfo] = [
        CarInfo(carName: "라세티", carNumber: "48소9953", typeFuel: .gasoline, typeShift: .Auto, maileage: 128999, insurance: .ssHwajae, maintenance: Maintenance(oilEngine: MaintenanceInfo(), oilMission: MaintenanceInfo(), fltAirConditioner: MaintenanceInfo(), fltOil: MaintenanceInfo())),
        CarInfo(carName: "트레일블레이저", carNumber: "000가0000", typeFuel: .gasoline, typeShift: .Auto, maileage: 0, insurance: .hhSangmyeong, maintenance: Maintenance(oilEngine: MaintenanceInfo(), oilMission: MaintenanceInfo(), fltAirConditioner: MaintenanceInfo(), fltOil: MaintenanceInfo()))]
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var carInfoView: UIView!
    @IBOutlet var lblCarNumber: UILabel!
    @IBOutlet var lblCarType: UILabel!
    @IBOutlet var lblCarMileage: UILabel!
    @IBOutlet var btnRenew: UIButton!
    
    var selectedCellNum: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
        configCollectionView()
    }

    func configView() {
        setNavigation()
        setTopBackgroundView()
        setMainInfoView()
        setBtnRenew()
    }
    
    func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        collectionView.backgroundColor = .systemGray6
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.collectionView?.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = layout
    }
    

}



// MARK: - [Extension] Config View
extension HomeViewController {
    
    func setNavigation() {
        let titleA = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        let titleB = UILabel(frame: CGRect(x: 23, y: 0, width: 20, height: 30))
        let titleC = UILabel(frame: CGRect(x: 40, y: 0, width: 50, height: 30))
        titleA.text = "my"
        titleB.text = "C"
        titleC.text = "arport"
        titleA.textAlignment = .right
        titleB.textAlignment = .center
        titleC.textAlignment = .left
        titleA.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleB.font = UIFont.systemFont(ofSize: 18, weight: .black)
        titleC.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleB.textColor = .systemTeal
        
        let titleContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        [titleA, titleB, titleC].forEach {
//            $0.backgroundColor = .orange.withAlphaComponent(0.3)
            titleContainerView.addSubview($0)
        }
        
        navigationItem.titleView = titleContainerView
//        navigationItem.title = "myCarport"
        navigationItem.rightBarButtonItem?.tintColor = .systemGray2
//        navigationController?.navigationBar.tintColor = .systemGray2
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func setTopBackgroundView() {
        viewBackground.backgroundColor = .systemGray6
        viewBackground.layer.cornerRadius = 30
        // 그림자 횩화
        viewBackground.layer.shadowColor = UIColor.systemGray.cgColor
        viewBackground.layer.shadowRadius = 1.0
        viewBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewBackground.layer.shadowOpacity = 0.5
    }
    
    func setMainInfoView() {
        carInfoView.backgroundColor = .systemTeal.withAlphaComponent(0.8)
        carInfoView.layer.cornerRadius = 20
    }
    
    func setBtnRenew() {
        btnRenew.layer.frame.size = CGSize(width: 20, height: 20)
        btnRenew.backgroundColor = .white
        btnRenew.clipsToBounds = true
        btnRenew.layer.cornerRadius = btnRenew.frame.height / 2 - 1
    }
}

// MARK: - [Extension] Config TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 섹션 정보
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return String("   보험")
        case 1:
            return String("   주기: 5천km")
        case 2:
            return "   주기: 1만km"
        case 3:
            return "   주기: 3만km"
        default:
            return ""
        }
    }

    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 60:20
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        let title = UILabel(frame: CGRect(x: 15, y: -0, width: 200, height: 80))
        
        title.text = "유지관리 항목"
        title.textAlignment = .left
        title.textColor = .systemTeal
        title.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        footerView.addSubview(title)
        return section == 0 ? footerView:nil
    }
    
    // 셀 정보
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1:4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell else { return UITableViewCell() }
        cell.layer.borderColor = UIColor.systemGray2.cgColor
        cell.layer.borderWidth = 0.5
        cell.lblCycle.backgroundColor = .systemGray4
        cell.lblCycle.layer.cornerRadius = 5
        cell.lblCycle.font = .systemFont(ofSize: 15, weight: .medium)
        cell.lblCycle.clipsToBounds = true
        if indexPath.section == 0 {
            cell.lblItemName.text = "삼성화재"
        } else {
            cell.lblItemName.text = "오일필터"
        }
        return cell
    }
    
    
}

// MARK: - [Extension] Config CollectionView
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCarList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = selectedCellNum == indexPath.row ? .systemTeal.withAlphaComponent(0.8):.systemGray4
        cell.layer.cornerRadius = 10
        if indexPath.row == 2 {
            cell.settingCell(name: "+")
        } else {
            cell.settingCell(name: myCarList[indexPath.row].carName)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellNum = indexPath.row
        collectionView.reloadData()
    }
    
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: indexPath.row == myCarList.count ? 30:70, height: 30)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    
}
