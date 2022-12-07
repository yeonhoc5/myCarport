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
    var myCarList: [CarInfo] = []
    
    var indexOfCar: Int = 0 {
        didSet {
            collectionView.reloadData()
            if indexOfCar < myCarList.count {
                tableView.reloadData()
            }
        }
    }
    // add 버튼 클릭 시 차를 추가하지 않고 뷰로 돌아올 시의 인덱스 임시 기억 값
    var selectedNumBefoAdd: Int = 0
    // data가 없을 시 나타나는 초기 텍스트
    var cycleList: [Int] = [5000, 10000, 30000, 40000, 50000, 60000, 80000, 100000, 120000]
    var cycleTitle: [String] = ["보험", "5천", "1만", "3만", "4만", "5만", "6만", "8만", "1십만", "12만"]
    var animationCount = [[Int]]()
    var randomNum: [UInt32]!
    // 초기 그래프를 위한 랜덤넘버 생성용 프라퍼티
    var sequence = 0
    
    
    //MARK: - 2. [View Did Load] view setting & [View Will Appear]
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
        configCollectionView()
        animationCount = (Array(repeating: Array(repeating: -1, count: 19), count: myCarList.count))
        if myCarList.isEmpty {
            randomNum = Array(repeating: arc4random_uniform(10) + 1, count: 19)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configData()
        indexOfCar = indexOfCar == myCarList.count ? selectedNumBefoAdd : indexOfCar
        configCarInfoData(carNum: indexOfCar)
        
    }
    
    //MARK: - 3.View Functions
    // 샘플 데이터 세팅
    func configData() {
        myCarList = appDelegate.carList
        if myCarList.isEmpty {
            randomNum = Array(repeating: arc4random_uniform(10) + 1, count: 19)
        } else {
            randomNum = []
        }
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
    // 콜렉션뷰 세팅 - 상단 차량 horizonal 리스트
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 0)
        collectionView.backgroundColor = .systemGray6
        collectionView.showsHorizontalScrollIndicator = false
    }
    // 상단 데이터 세팅
    func configCarInfoData(carNum: Int) {
        lblCarNumber.text = myCarList.isEmpty ? "--" : myCarList[carNum].carNumber
        lblCarType.text = myCarList.isEmpty ? "--" : "\(myCarList[carNum].typeFuel == .gasoline ? "휘발유":"경유") (\(myCarList[carNum].typeShift == .Auto ? "오토":"스틱"))"
        lblCarMileage.text = myCarList.isEmpty ? "--" : "\(myCarList[carNum].mileage) km"
    }
    // 주행거리 갱신버튼 액션
    @IBAction func tabBtnRenew(_ sender: UIButton) {
        let alert = myCarList.isEmpty ? emptyAlert() : renewAlert()
        self.present(alert, animated: true)
    }
    func emptyAlert() -> UIAlertController {
        let alert = UIAlertController(title: "등록된 차량이 없습니다.", message: "차량 등록 후 이용해 주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        return alert
    }
    func renewAlert() -> UIAlertController {
        let alert = UIAlertController(title: "주행거리를 갱신합니다.", message: nil, preferredStyle: .alert)
        alert.addTextField{
            $0.placeholder = "현재 주행거리를 입력해주세요."
            $0.textAlignment = .center
            $0.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "갱신하기", style: .default, handler: { _ in
            if let mileage: Int = Int(alert.textFields?[0].text ?? "") {
                self.appDelegate.carList[self.indexOfCar].mileage = mileage
                self.myCarList = self.appDelegate.carList
                self.animationCount[self.indexOfCar] = Array(repeating: -1, count: 18)
                self.configCarInfoData(carNum: self.indexOfCar)
                self.tableView.reloadSections(IndexSet(0..<self.tableView.numberOfSections), with: .none)
            }
        }))
        return alert
    }
    func randomeArray() -> UInt32 {
        let num: UInt32
        if sequence <= appDelegate.itemList.count {
            num = randomNum[sequence]
            sequence += 1
        } else {
            num = arc4random_uniform(10) + 1
        }
        return num
    }
}


// MARK: - 4. [Extension] Config View
extension HomeViewController {
    func setNavigation() {
        // titleView 커스터마이징
        let titleContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
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
        navigationItem.titleView = titleContainerView
        // navigation color
        navigationItem.rightBarButtonItem?.tintColor = .systemGray2
        navigationController?.navigationBar.tintColor = .systemTeal
        // navigationbar 경계선, 그림자 없애기
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
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
        viewCarInfo.layer.cornerRadius = 10
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
        return section == 0 ? cycleTitle[section]:"주기 : \(cycleTitle[section])km"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.text = headerView.textLabel?.text?.lowercased()
        }
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
            guard indexOfCar < myCarList.count else { return 0 }
            return section == 0 ? 1 : myCarList[self.indexOfCar].maintenance.filter{$0.cycleMileage == cycleList[section - 1]}.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier: String = indexPath.section == 0 ? "HomeCellInsurance":"HomeCellItem"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeTableViewCell else { return UITableViewCell() }
        // 공통 레이아웃
        cell.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.layer.borderWidth = 0.5
        // 그래프용 properties
        var compareValue: Int!
        var currentValue: Int!
        // 셀에 나타나는 정보 (보험과 관리항목 셀 구분 적용)
        if myCarList.isEmpty {
            switch indexPath.section {
            case 0: cell.settingInsurance(type: .empty, strEmpty: " ⃝ ⃝ 보험")
            default:
                let items = appDelegate.itemList.filter{ $0.1 == cycleList[indexPath.section - 1]}
                cell.settingItem(type: .empty, itemName: items[indexPath.row].0)
            }
        } else {
            switch indexPath.section {
            case 0:
                if myCarList[indexOfCar].insurance.isEmpty {
                    cell.settingInsurance(type: .empty, periodHidden: true, strEmpty: "보험 정보 없음")
                } else {
                    if let lastInsurance: Insurance = myCarList[indexOfCar].insurance.last {
                        cell.settingInsurance(type: .last,insurance: lastInsurance)
                        compareValue = 365
                        currentValue = -Int(lastInsurance.dateStart.timeIntervalSinceNow / 3600 / 24)
                    }
                }
            default:
                let item = myCarList[indexOfCar].maintenance.filter { $0.cycleMileage == cycleList[indexPath.section - 1] }[indexPath.row]
                if item.historyManage.isEmpty {
                    cell.settingItem(type: .empty, lastHidden: true, itemName: item.nameOfItem, strEmpty: "관리 기록 없음")
                } else {
                    if let lastHistory = item.historyManage.last {
                        let gapMileage: Int = myCarList[indexOfCar].mileage - lastHistory.mileage
                        let cycle: Int = item.cycleMileage
                        cell.settingItem(type: .last, itemName: item.nameOfItem, lastHistory: lastHistory, gapMileage: gapMileage, cycle: cycle)
                        compareValue = cycle
                        currentValue = gapMileage
                    }
                }
            }
        }
        // 그래프 레이아웃
        if self.myCarList.isEmpty {
            cell.viewGraphStick.frame.size.width = cell.frame.width * (CGFloat(randomeArray())/10)
        } else {
            switch indexPath.section {
            case 0:
                let item = myCarList[indexOfCar]
                if item.insurance.isEmpty {
                    cell.viewGraphStick.frame.size.width = 0
                } else {
                    if animationCount[indexOfCar][0] == item.insurance.count {
                        cell.viewGraphStick.frame.size.width = currentValue < compareValue ? cell.frame.width * CGFloat(currentValue) / CGFloat(compareValue) : cell.frame.width
                    } else {
                        UIView.animate(withDuration: 1, delay: 0) {
                            cell.viewGraphStick.frame.size.width = currentValue < compareValue ? cell.frame.width * CGFloat(currentValue) / CGFloat(compareValue) : cell.frame.width
                            self.animationCount[self.indexOfCar][0] = item.insurance.count
                        }
                    }
                }
            default:
                let item = myCarList[indexOfCar].maintenance.filter { $0.cycleMileage == cycleList[indexPath.section - 1] }[indexPath.row]
                if item.historyManage.isEmpty {
                    cell.viewGraphStick.frame.size.width = 0
                } else {
                    if animationCount[indexOfCar][item.id + 1] == item.historyManage.count {
                        cell.viewGraphStick.frame.size.width = currentValue < compareValue ? cell.frame.width * CGFloat(currentValue) / CGFloat(compareValue) : cell.frame.width
                    } else {
                        UIView.animate(withDuration: 1, delay: 0.4) {
                            cell.viewGraphStick.frame.size.width = currentValue < compareValue ? cell.frame.width * CGFloat(currentValue) / CGFloat(compareValue) : cell.frame.width
                            self.animationCount[self.indexOfCar][item.id + 1] = item.historyManage.count
                        }
                    }
                }
            }
        }
        cell.viewGraphStick.backgroundColor = cell.viewGraphStick.frame.width == cell.frame.width ? .systemPink.withAlphaComponent(0.4): .systemTeal.withAlphaComponent(0.4)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let InsuranceVC = storyboard?.instantiateViewController(withIdentifier: "InsuranceDetailViewController") as? InsuranceDetailViewController else { return }
            InsuranceVC.indexOfCar = self.indexOfCar
            if !myCarList.isEmpty && !myCarList[indexOfCar].insurance.isEmpty {
                    InsuranceVC.insurances = myCarList[indexOfCar].insurance
            }
            navigationController?.pushViewController(InsuranceVC, animated: true)
        default:
            guard let ItemDetailVC = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController else { return }
            if !myCarList.isEmpty {
                let carInfo = myCarList[self.indexOfCar]
                let items = carInfo.maintenance.filter({ item in
                    item.cycleMileage == cycleList[indexPath.section - 1]
                })
                ItemDetailVC.indexOfCar = self.indexOfCar
                ItemDetailVC.maintenance = items[indexPath.row]
                ItemDetailVC.idOfMaintenance = items[indexPath.row].id
                ItemDetailVC.navigationItem.title = "\(items[indexPath.row].nameOfItem) 관리 내역"
            }
            navigationController?.pushViewController(ItemDetailVC, animated: true)
        }
    }
    
}

// MARK: - 6. [Extension] Config CollectionView

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    // Data Source
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
            bgColor = indexOfCar == indexPath.row ? .systemTeal.withAlphaComponent(0.8) : .systemGray4
        }
        cell.settingCell(name: name)
        cell.backgroundColor = bgColor
        cell.layer.cornerRadius = 10
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let AddCarVC = storyboard?.instantiateViewController(withIdentifier: "AddCarViewController") as? AddAndEditCarViewController else { return }
        AddCarVC.modalPresentationStyle = .fullScreen
        AddCarVC.delegate = self
        if myCarList.isEmpty {
            if indexPath.row == 0 {
                self.present(AddCarVC, animated: true)
                DispatchQueue.main.async {
                    collectionView.cellForItem(at: indexPath)?.backgroundColor = .systemTeal
                }
            }
        } else {
            if indexPath.row >= myCarList.count {
                selectedNumBefoAdd = indexOfCar
            }
            indexOfCar = indexPath.row
            if indexOfCar < myCarList.count {
                configCarInfoData(carNum: indexOfCar)
            } else {
                self.present(AddCarVC, animated: true)
            }
        }
        
    }
}



