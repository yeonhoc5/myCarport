//
//  HomeViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/01.
//

import UIKit
import SnapKit


class HomeViewController: UIViewController {

    // subView1
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    // selfViewContent
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var viewCarInfo: UIView!
    @IBOutlet var lblCarNumber: UILabel!
    @IBOutlet var lblCarType: UILabel!
    @IBOutlet var lblCarMileage: UILabel!
    @IBOutlet var btnRenew: UIButton!
    // property
    var myCarList: [CarInfo] = carListSample
    var selectedCellNum: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //viewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
        configCollectionView()
        configCarInfoView(carNum: 0)
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
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configCarInfoView(carNum: Int) {
        let selectedCar = myCarList[carNum]
        lblCarNumber.text = selectedCar.carNumber
        lblCarType.text = "\(selectedCar.typeFuel == .gasoline ? "가솔린":"디젤") (\(selectedCar.typeShift == .Auto ? "오토":"스틱"))"
        lblCarMileage.text = "\(selectedCar.mileage) km"
    
    }
    
    
    
    @IBAction func tabBtnRenew(_ sender: UIButton) {
        let alert = UIAlertController(title: "주행거리를 갱신합니다.", message: nil, preferredStyle: .alert)
        alert.addTextField{
            $0.placeholder = "현재 주행거리를 입력해주세요."
            $0.textAlignment = .center
            $0.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "갱신하기", style: .default, handler: { _ in
            if let mileage: Int = Int(alert.textFields?[0].text ?? "") {
                self.myCarList[self.selectedCellNum].mileage = mileage
                DispatchQueue.main.async {
                    self.configCarInfoView(carNum: self.selectedCellNum)
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
    

}


// MARK: - [Extension] Config View
extension HomeViewController {
    func setNavigation() {
        // title Customizing
        let titleContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        navigationItem.titleView = titleContainerView
        
        let titleA = UILabel(width: 25, height: 30, text: "my", aliignment: .right, doFit: true)
        let titleB = UILabel(width: 20, height: 30, text: "C", aliignment: .center, fontSize: 19, fontWeight: .black, fontColor: .systemTeal, doFit: true)
        let titleC = UILabel(width: 50, height: 30, text: "arport", aliignment: .left, doFit: true)
        [titleA, titleB, titleC].forEach { titleContainerView.addSubview($0) }
        titleA.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        titleB.snp.makeConstraints {
            $0.leading.equalTo(titleA.snp.trailing)
            $0.centerY.equalToSuperview()
        }
        titleC.snp.makeConstraints {
            $0.leading.equalTo(titleB.snp.trailing)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        // navigation color
        navigationItem.rightBarButtonItem?.tintColor = .systemGray2
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setTopBackgroundView() {
        viewBackground.backgroundColor = .systemGray6
        viewBackground.layer.cornerRadius = 30
        // 상단 백그라운드 그림자 효과
        viewBackground.layer.shadowColor = UIColor.systemGray.cgColor
        viewBackground.layer.shadowRadius = 1.0
        viewBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewBackground.layer.shadowOpacity = 0.5
    }
    
    func setMainInfoView() {
        viewCarInfo.backgroundColor = .systemTeal.withAlphaComponent(0.8)
        viewCarInfo.layer.cornerRadius = 20
    }
    
    func setBtnRenew() {
        btnRenew.layer.frame.size = CGSize(width: 20, height: 20)
        
        btnRenew.clipsToBounds = true
        btnRenew.layer.cornerRadius = btnRenew.frame.height / 2 - 1
        let configurations = UIImage.SymbolConfiguration(pointSize: 10, weight: .heavy)
        btnRenew.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: configurations), for: .normal)
        btnRenew.backgroundColor = btnRenew.isHighlighted ? .orange:.white
    }
}

// MARK: - [Extension] Config TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // 섹션 정보
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableInfoList = ["보험", "주기 : 5천km", "주기 : 1만km", "주기 : 3만km", "주기 : 4만km"]
        return tableInfoList[section]
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 60:20
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        let title = UILabel(x: 15, width: 200, height: 80, text: "유지관리 항목", aliignment: .left, fontSize: 17, fontWeight: .bold, fontColor: .systemTeal)
        footerView.addSubview(title)
        return section == 0 ? footerView : nil
    }
    // 셀 정보
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell else { return UITableViewCell() }
        cell.layer.borderColor = UIColor.systemGray2.cgColor
        cell.layer.borderWidth = 0.5
        cell.lblCycle.font = .systemFont(ofSize: 15, weight: .medium)
        cell.viewGraphStick.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.4)
        
        if indexPath.section == 0 {
            cell.lblItemName.text = "삼성화재"
        } else {
            cell.lblItemName.text = "오일필터"
        }
        return cell
    }
    
    
}

// MARK: - [Extension] Config CollectionView

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: indexPath.row == myCarList.count ? 30:70, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCarList.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        let name = indexPath.row < myCarList.count ? myCarList[indexPath.row].carName : "+"
        let bgColor: UIColor = selectedCellNum == indexPath.row ? .systemTeal.withAlphaComponent(0.8) : .systemGray4
        cell.settingCell(name: name)
        cell.backgroundColor = bgColor
        cell.layer.cornerRadius = 10
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellNum = indexPath.row
        if selectedCellNum < myCarList.count {
            configCarInfoView(carNum: selectedCellNum)
        }
    }
}
