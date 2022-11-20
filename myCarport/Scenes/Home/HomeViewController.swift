//
//  HomeViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/01.
//

import UIKit
import SnapKit


class HomeViewController: UIViewController {
    
// MARK: - 1. Properties & Outlets
    // subViews
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    // outletProperties
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var viewCarInfo: UIView!
    @IBOutlet var lblCarNumber: UILabel!
    @IBOutlet var lblCarType: UILabel!
    @IBOutlet var lblCarMileage: UILabel!
    @IBOutlet var btnRenew: UIButton!
    // data properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var myCarList: [CarInfo]! = []
    var selectedCellNum: Int = 0 {
        didSet {
            collectionView.reloadData()
            if selectedCellNum < myCarList.count {
                tableView.reloadData()
            }
        }
    }
    var selectedNumBfAdd: Int = 0
    var cycleList: [Int] = [5000, 10000, 30000, 40000, 50000, 60000, 80000, 100000, 120000]
    let strEmpty: String = "--"
    
//MARK: - 2. [View Did Load] view setting
    override func viewDidLoad() {
        super.viewDidLoad()
        sampleTest()
        configView()
        configTableView()
        configCollectionView()
        configCarInfoView(carNum: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedCellNum = selectedCellNum == myCarList.count ? selectedNumBfAdd : selectedCellNum
    }
    
//MARK: - 3.View Functions
    // 샘플 데이터 세팅
    func sampleTest() {
        myCarList = appDelegate.carListSample
    }
    // 상단뷰 세팅
    func configView() {
        setNavigation()
        setTopBackgroundView()
        setMainInfoView()
        setBtnRenew()
    }
    // 테이블뷰 세팅 - 아이템 리스트
    func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .clear
    }
    // 콜렉션뷰 세팅 - 상단 차량 리스트
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 0)
        collectionView.backgroundColor = .systemGray6
        collectionView.showsHorizontalScrollIndicator = false
    }
    // 상단 데이터 세팅
    func configCarInfoView(carNum: Int) {
        if myCarList.isEmpty {
            lblCarNumber.text = strEmpty
            lblCarType.text = strEmpty
            lblCarMileage.text = strEmpty
        } else {
            let selectedCar = myCarList[carNum]
            lblCarNumber.text = selectedCar.carNumber
            lblCarType.text = "\(selectedCar.typeFuel == .gasoline ? "가솔린":"디젤") (\(selectedCar.typeShift == .Auto ? "오토":"스틱"))"
            lblCarMileage.text = "\(selectedCar.mileage) km"
        }
        
    }
    // 주행거리 갱신버튼 알럿
    @IBAction func tabBtnRenew(_ sender: UIButton) {
        let alert: UIAlertController
        if myCarList.isEmpty {
            alert = UIAlertController(title: "등록된 차량이 없습니다.", message: "차량 등록 후 이용해 주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
        } else {
            alert = UIAlertController(title: "주행거리를 갱신합니다.", message: nil, preferredStyle: .alert)
            alert.addTextField{
                $0.placeholder = "현재 주행거리를 입력해주세요."
                $0.textAlignment = .center
                $0.keyboardType = .numberPad
            }
            alert.addAction(UIAlertAction(title: "갱신하기", style: .default, handler: { _ in
                if let mileage: Int = Int(alert.textFields?[0].text ?? "") {
                    self.appDelegate.carListSample[self.selectedCellNum].mileage = mileage
                    self.myCarList = self.appDelegate.carListSample
//                    self.myCarList[self.selectedCellNum].mileage = mileage
                    DispatchQueue.main.async {
                        self.configCarInfoView(carNum: self.selectedCellNum)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        }
        self.present(alert, animated: true)
    }
}


// MARK: - 4. [Extension] Config View
extension HomeViewController {
    func setNavigation() {
        // title Customizing
        let titleContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        navigationItem.titleView = titleContainerView
        
        let titleA = UILabel(width: 25, height: 30, text: "my", aliignment: .right, doFit: true)
        let titleB = UILabel(width: 20, height: 30, text: "C", aliignment: .center, size: 19, weight: .black, fontColor: .systemTeal, doFit: true)
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
        navigationController?.navigationBar.tintColor = .systemTeal
        
    }
    func setTopBackgroundView() {
        viewBackground.backgroundColor = .systemGray6
        viewBackground.layer.cornerRadius = 20
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
        btnRenew.layer.cornerRadius = btnRenew.frame.height / 2 - 1
        btnRenew.clipsToBounds = true
        let configurations = UIImage.SymbolConfiguration(pointSize: 10, weight: .heavy)
        btnRenew.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: configurations), for: .normal)
    }
}

// MARK: - 5. [Extension] Config TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // 섹션 정보
    func numberOfSections(in tableView: UITableView) -> Int {
        return cycleList.count + 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var tableTitleList: [String] = cycleList.map{ "주기 : \($0) km" }
        tableTitleList.insert("보험", at: 0)
        return tableTitleList[section]
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 60:20
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        let title = UILabel(x: 15, width: 200, height: 80, text: "유지관리 항목", aliignment: .left, size: 17, weight: .bold, fontColor: .systemTeal)
        footerView.addSubview(title)
        return section == 0 ? footerView : nil
    }
    // 셀 정보
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myCarList.isEmpty {
            return section == 0 ? 1 : appDelegate.itemList.filter{$0.1 == cycleList[section - 1]}.count
        } else {
            guard selectedCellNum < myCarList.count else { return 0 }
            return section == 0 ? 1 : myCarList[self.selectedCellNum].maintenance.filter{$0.cycleMileage == cycleList[section - 1]}.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String!
        switch indexPath.section {
        case 0: identifier = "HomeCellInsurance"
        default: identifier = "HomeCellItem"
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeTableViewCell else { return UITableViewCell() }
        cell.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.layer.borderWidth = 0.5
        cell.viewGraphStick.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.4)
        cell.lblItemName.font = .systemFont(ofSize: 17, weight: .semibold, width: .condensed)
        cell.lblItemName.textColor = .label
        if myCarList.isEmpty {
            if indexPath.section == 0 {
                cell.lblItemName.text = "\(strEmpty) 보험"
                cell.lblPeriod.numberOfLines = 2
                cell.lblPeriod.font = .systemFont(ofSize: 13, weight: .medium)
                cell.lblPeriod.textColor = .secondaryLabel
                cell.lblPeriod.text = strEmpty
            } else {
                let items = appDelegate.itemList.filter{ $0.1 == cycleList[indexPath.section - 1]}
                cell.lblItemName.text = items[indexPath.row].0
                cell.lblCycle.font = .systemFont(ofSize: 15, weight: .medium)
                cell.lblCycle.textColor = .secondaryLabel
                cell.lblLastMileage.font = .systemFont(ofSize: 12, weight: .medium)
                cell.lblLastMileage.textColor = .secondaryLabel
                cell.lblCycle.text = strEmpty
                cell.lblLastMileage.text = "(last: \(strEmpty) km)"
            }
        } else {
            guard selectedCellNum < myCarList.count else { return cell }
            if indexPath.section == 0 {
                cell.lblItemName.text = "삼성화재"
                cell.lblPeriod.numberOfLines = 2
                cell.lblPeriod.font = .systemFont(ofSize: 13, weight: .medium)
                cell.lblPeriod.textColor = .secondaryLabel
                cell.lblPeriod.text = "2022/05/23\t\n~2023/05/22"
            } else {
                cell.lblCycle.font = .systemFont(ofSize: 15, weight: .medium)
                cell.lblCycle.textColor = .secondaryLabel
                cell.lblLastMileage.font = .systemFont(ofSize: 12, weight: .medium)
                cell.lblLastMileage.textColor = .secondaryLabel
                let items = myCarList[self.selectedCellNum].maintenance.filter({ item in
                    item.cycleMileage == cycleList[indexPath.section - 1]
                })
                cell.lblItemName.text = "\(items[indexPath.row].nameOfItem)"
                if let item = items[indexPath.row].historyManage?.last {
                    cell.lblCycle.text = "\(cycleList[indexPath.section - 1] - item.mileage)"
                    cell.lblLastMileage.text = "(last: \(item.mileage) km)"
                } else {
                    cell.lblCycle.text = "--"
                    cell.lblLastMileage.text = "(last: -- km)"
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let InsuranceVC = storyboard?.instantiateViewController(withIdentifier: "InsuranceDetailViewController") as? InsuranceDetailViewController else { return }
            navigationController?.pushViewController(InsuranceVC, animated: true)
        default:
            guard let ItemDetailVC = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController else { return }
            let items = myCarList[self.selectedCellNum].maintenance.filter({ item in
                item.cycleMileage == cycleList[indexPath.section - 1]
            })
            ItemDetailVC.navigationItem.title = "\(items[indexPath.row].nameOfItem) 관리 내역"
            navigationController?.pushViewController(ItemDetailVC, animated: true)
        }
    }
    
    
    
}

// MARK: - 6. [Extension] Config CollectionView

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
        let supplCellCount = myCarList.isEmpty ? 2:1
        return myCarList.count + supplCellCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        let name: String
        let bgColor: UIColor
        if myCarList.isEmpty {
            name = indexPath.row == 0 ? "+" : "\"+\" 버튼을 눌러 차량을 추가하세요."
            bgColor = indexPath.row == 0 ? .systemGray4 : .systemGray6
        } else {
            name = indexPath.row < myCarList.count ? myCarList[indexPath.row].carName : "+"
            bgColor = selectedCellNum == indexPath.row ? .systemTeal.withAlphaComponent(0.8) : .systemGray4
        }
        cell.settingCell(name: name)
        cell.backgroundColor = bgColor
        cell.layer.cornerRadius = 10
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let AddCarVC = storyboard?.instantiateViewController(withIdentifier: "AddCarViewController") as? AddCarViewController else { return }
        AddCarVC.modalPresentationStyle = .fullScreen
        if myCarList.isEmpty {
            if indexPath.row == 0 {
                self.present(AddCarVC, animated: true)
                DispatchQueue.main.async {
                    collectionView.cellForItem(at: indexPath)?.backgroundColor = .systemTeal
                }
            }
        } else {
            if indexPath.row >= myCarList.count {
                selectedNumBfAdd = selectedCellNum
            }
            selectedCellNum = indexPath.row
            if selectedCellNum < myCarList.count {
                configCarInfoView(carNum: selectedCellNum)
            } else {
                self.present(AddCarVC, animated: true)
            }
        }
    }
}
