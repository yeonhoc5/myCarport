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
    // outlets 1-1. subClassView Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    // outlets 1-2. upper CarInfoField Outlets
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var viewCarInfo: UIView!
    @IBOutlet var lblCarNumber: UILabel!
    @IBOutlet var lblCarType: UILabel!
    @IBOutlet var lblCarMileage: UILabel!
    @IBOutlet var btnRenew: UIButton!
    
    // property 1-1. carInfo properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var dao = CarInfoDAO()
    var myCarList: [CarInfo] = []
    // property 1-2. 관리주기별 섹션용 property
    var cycleList: [Int] = []
    // property 1-3. 현재 선택한 차량 정보 - 차량 선택시 화면 갱신
    var indexOfCar: Int = 0 {
        didSet {
            if indexOfCar < myCarList.count {
                tableView.reloadData()
            }
        }
    }
    // property 1-4. tableView 그래프 애니메이션용 프라퍼티 : animationcount.count = 마이카리스트.count
    var animationCount = [[Int]]()
    // property 1-5. add 버튼 클릭 시 차를 추가하지 않고 뷰로 돌아올 시의 인덱스 임시 기억 값
    var selectedNumBefoAdd: Int = 0
    
    //MARK: - 2. [View Did Load] view setting & [View Will Appear]
    override func viewDidLoad() {
        super.viewDidLoad()
        // 초기 데이터 세팅
        settingInitialData()
        // 뷰 세팅
        configNavigation()
        configCarInfoView()
        configTableView()
        configCollectionView()
    }
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myCarList = appDelegate.myCarList
        if myCarList.isEmpty {
            settingInitialData()
        } else if indexOfCar == myCarList.count {
            if selectedNumBefoAdd < myCarList.count {
                indexOfCar = selectedNumBefoAdd
            } else {
                indexOfCar = myCarList.count - 1
            }
        } else {
            self.configCarInfoData(carNum: self.indexOfCar)
            configTableViewData()
        }
        self.collectionView.reloadData()
    }
    
    //MARK: - 3.View Functions
    // 초기 진입 시/차량 모두 삭제 시 animationcount & cyclelist 설정
    func settingInitialData() {
        appDelegate.myCarList = dao.fetch()
        self.myCarList = appDelegate.myCarList
        self.animationCount.removeAll()
        for car in myCarList {
            self.animationCount.append(Array(repeating: -1, count: car.maintenance.count + 1))
        }
        UIView.animate(withDuration: 0.35, delay: 0) {
            self.configCarInfoData(carNum: self.indexOfCar, animationRange: .all)
        }
        configTableViewData()
    }
    // 상단 데이터 세팅
    func configCarInfoData(carNum: Int, beforNum: Int! = nil, animationRange: AnimationRange = .none) {
        let carInfo = myCarList.isEmpty ? appDelegate.sampleCar : myCarList[carNum]
        
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push //1.
        if let beforNum = beforNum {
            animation.subtype = beforNum < carNum ? .fromRight : (beforNum > carNum ? .fromLeft : .fromBottom )
        } else {
            animation.subtype = .fromBottom
        }
        animation.duration = 0.3
        
        if animationRange == .all {
            self.lblCarNumber.layer.add(animation, forKey: CATransitionType.push.rawValue)
            self.lblCarType.layer.add(animation, forKey: CATransitionType.push.rawValue)
            self.lblCarMileage.layer.add(animation, forKey: CATransitionType.push.rawValue)
        } else if animationRange == .one {
            self.lblCarMileage.layer.add(animation, forKey: CATransitionType.push.rawValue)
        }
        
        self.lblCarNumber.text = carInfo.carNumber
        self.lblCarType.text = "\(carInfo.typeFuel.rawValue.toTypeFuelString()) (\(carInfo.typeShift.rawValue.toTypeShiftString()))"
        self.lblCarMileage.text = "\(Funcs.addCommaToNumber(number: carInfo.mileage)) km"
        
        UIView.animate(withDuration: 0.25) {
            self.collectionView.reloadData()
        }
    }
    // 상단뷰 세팅
    func configCarInfoView() {
        setTopBackgroundView()
        setMainInfoView()
        setBtnRenew()
    }
    // 콜렉션뷰 세팅 - 상단 차량 horizonal 리스트
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 20)
        collectionView.backgroundColor = .systemGray6
        collectionView.showsHorizontalScrollIndicator = false
    }
    // 테이블뷰 seciton 설정
    func configTableViewData() {
        if myCarList.isEmpty {
            self.cycleList = Array(Set(appDelegate.gasolineItemList.compactMap{$0.1})).sorted(by: {$0 < $1})
        } else {
            self.cycleList = Array(Set(myCarList[indexOfCar].maintenance.compactMap{$0.cycleMileage})).sorted(by: {$0 < $1})
        }
        self.tableView.reloadData()
    }
    // 테이블뷰 세팅 - 아이템 리스트
    func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .clear
    }
    // 주행거리 갱신버튼 액션
    @IBAction func tabBtnRenew(_ sender: UIButton) {
        let alert = myCarList.isEmpty ? emptyAlert() : renewMileageAlert()
        self.present(alert, animated: true)
    }
    func emptyAlert() -> UIAlertController {
        let alert = UIAlertController(title: "등록된 차량이 없습니다.", message: "차량 등록 후 이용해 주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        return alert
    }
    func renewMileageAlert() -> UIAlertController {
        let carName = myCarList[indexOfCar].carName
        let alert = UIAlertController(title: "[\(carName)]의 주행거리를 갱신합니다.", message: nil, preferredStyle: .alert)
        alert.addTextField{
            $0.placeholder = "현재 주행거리를 입력해주세요."
            $0.textAlignment = .center
            $0.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "갱신하기", style: .default, handler: { _ in
            if let mileage: Int = Int(alert.textFields?[0].text ?? ""),
               let carID = self.myCarList[self.indexOfCar].objectID {
                if self.dao.renewMileage(carID: carID, mile: mileage) {
                    self.appDelegate.myCarList = self.dao.fetch()
                    self.myCarList[self.indexOfCar] = self.appDelegate.myCarList[self.indexOfCar]
                    self.animationCount[self.indexOfCar] = Array(repeating: -1, count: self.myCarList[self.indexOfCar].maintenance.count + 1)
                    self.animationCount[self.indexOfCar][0] = self.myCarList[self.indexOfCar].insurance.count
                    self.configCarInfoData(carNum: self.indexOfCar, animationRange: .one)
                    self.tableView.reloadSections(IndexSet(1...self.cycleList.count), with: .automatic)
                }
            }
        }))
        return alert
    }
//    func randorandom
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        selectedNumBefoAdd = 0
        if segue.identifier == "segueSetting" {
            if let settingVC = segue.destination as? SettingViewController {
                settingVC.myCarList = self.myCarList
                settingVC.delegate = self
            }
        }
    }
}



// MARK: - 4. [Extension] Config View
extension HomeViewController {
    func configNavigation() {
        // titleView 커스터마이징
        let titleContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        let titleA = UILabel(width: 25, height: 30, text: "my", aliignment: .right, doFit: true)
        let titleB = UILabel(width: 20, height: 30, text: "C", aliignment: .center,
                             size: 19, weight: .black, fontColor: .systemTeal, doFit: true)
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

        // navigationbar 경계선, 그림자 없애기
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        // navigation color
        navigationItem.rightBarButtonItem?.tintColor = .systemGray2
        navigationItem.leftBarButtonItem?.tintColor = .systemGray2
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
        viewCarInfo.layer.cornerRadius = 10
    }
    func setBtnRenew() {
        let configurations = UIImage.SymbolConfiguration(pointSize: 10, weight: .heavy)
        btnRenew.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: configurations), for: .normal)
    }
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
        btnRenew.layer.cornerRadius = btnRenew.bounds.height / 2
        btnRenew.clipsToBounds = true
    }
    
}

// MARK: - 5. [Extension] Config TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // 섹션 정보
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cycleList.count + 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "보험"
        default:
            return "주기 : \(Funcs.numberToString(number: cycleList[section - 1]))"
        }
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
            return section == 0 ? 1 : appDelegate.gasolineItemList.filter{$0.1 == cycleList[section - 1]}.count
        } else {
            return section == 0 ? 1 : myCarList[indexOfCar].maintenance.filter{$0.cycleMileage == cycleList[section - 1]}.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier: String = indexPath.section == 0 ? "HomeCellInsurance" : "HomeCellItem"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeTableViewCell else { return UITableViewCell() }
        // 공통 레이아웃
        cell.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.layer.borderWidth = 0.7
        // 그래프용 properties
        var compareValue: Int!
        var currentValue: Int!
        // 셀에 나타나는 정보 (보험과 관리항목 셀 구분 적용)
        if myCarList.isEmpty {
            switch indexPath.section {
            case 0: cell.settingInsurance(type: .last, insurance: appDelegate.sampleInsurance.last)
            default:
                let items = appDelegate.gasolineItemList.filter{ $0.1 == cycleList[indexPath.section - 1]}
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
                        currentValue = -Int(lastInsurance.dateStart!.timeIntervalSinceNow / 3600 / 24)
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
            cell.viewGraphStick.frame.size.width = cell.frame.width * (CGFloat(appDelegate.tempGraphArray[(indexPath.section + 1) * (indexPath.row + 1)]) / 20)
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
                let item = myCarList[indexOfCar].maintenance.filter{ $0.cycleMileage == cycleList[indexPath.section - 1] }[indexPath.row]
                let index = myCarList[indexOfCar].maintenance.filter{ $0.cycleMileage < cycleList[indexPath.section - 1] }.count + indexPath.row + 1
                if item.historyManage.isEmpty {
                    cell.viewGraphStick.frame.size.width = 0
                } else {
                    if animationCount[indexOfCar][index] == item.historyManage.count {
                        cell.viewGraphStick.frame.size.width = currentValue < compareValue ? cell.frame.width * CGFloat(currentValue) / CGFloat(compareValue) : cell.frame.width
                    } else {
                        UIView.animate(withDuration: 1, delay: 0.4) {
                            cell.viewGraphStick.frame.size.width = currentValue < compareValue ? cell.frame.width * CGFloat(currentValue) / CGFloat(compareValue) : cell.frame.width
                            self.animationCount[self.indexOfCar][index] = item.historyManage.count
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
            if !myCarList.isEmpty {
                let carInfo = myCarList[indexOfCar]
                InsuranceVC.carInfo = carInfo
                InsuranceVC.insurances = carInfo.insurance
            }
            navigationController?.pushViewController(InsuranceVC, animated: true)
        default:
            guard let ItemDetailVC = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController else { return }
            if !myCarList.isEmpty {
                let carInfo = myCarList[indexOfCar],
                    items = carInfo.maintenance.filter{ $0.cycleMileage == cycleList[indexPath.section - 1] }
                ItemDetailVC.carInfo = carInfo
                ItemDetailVC.maintenance = items[indexPath.row]
                ItemDetailVC.navigationtitle = carInfo.carName
                ItemDetailVC.itemTitle = "\(items[indexPath.row].nameOfItem) (관리 주기 : \(Funcs.numberToString(number: items[indexPath.row].cycleMileage)) km)"
            } else {
                let items = appDelegate.gasolineItemList.filter{ $0.1 == cycleList[indexPath.section - 1] }
                ItemDetailVC.navigationtitle = "샘플 차량"
                ItemDetailVC.itemTitle = "\(items[indexPath.row].0) (관리 주기 : \(Funcs.numberToString(number: items[indexPath.row].1)) km)"
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
        return 7
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
        DispatchQueue.main.async {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .systemTeal
        }
            if indexPath.row < myCarList.count {
                if indexOfCar != indexPath.row {
                    let beforeNum = indexOfCar
                    indexOfCar = indexPath.row
                    configCarInfoData(carNum: indexOfCar, beforNum: beforeNum, animationRange: .all)
                }
            } else {
                selectedNumBefoAdd = indexOfCar
                indexOfCar = myCarList.count
                self.present(AddCarVC, animated: true)
                
            }
    }
}


extension HomeViewController: ChangeAnimationCount {
    func addAnimationCount(count: Int) {
        animationCount.append(Array(repeating: -1, count: count))
    }
    
    func removeAnimationCount(at: Int) {
        animationCount.remove(at: at)
    }
}

