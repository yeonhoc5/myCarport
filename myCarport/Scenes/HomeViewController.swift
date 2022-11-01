//
//  HomeViewController.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/01.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var carInfoView: UIView!
    @IBOutlet var lblCarNumber: UILabel!
    @IBOutlet var lblCarType: UILabel!
    @IBOutlet var lblCarMileage: UILabel!
    @IBOutlet var btnRenew: UIButton!
    
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
        tableView.backgroundColor = .systemBackground
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        collectionView.backgroundColor = .systemGray6
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        layout.collectionView?.showsHorizontalScrollIndicator = false
    }
    

}



// MARK: - [Extension] Config View
extension HomeViewController {
    
    func setNavigation() {
        navigationItem.title = "myCarport"
        navigationController?.navigationBar.tintColor = .systemGray2
        
    }
    
    func setTopBackgroundView() {
        viewBackground.backgroundColor = .systemGray6
        viewBackground.layer.cornerRadius = 30
        // 그림자 횩화
        viewBackground.layer.shadowColor = UIColor.systemGray.cgColor
        viewBackground.layer.shadowRadius = 8.0
        viewBackground.layer.shadowOffset = CGSize(width: 0, height: 2)
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
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "보험":"유지관리 항목"
    }
    // 셀 정보
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1:10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    
}

// MARK: - [Extension] Config CollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: indexPath.row <= 2 ? 80:30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemTeal.withAlphaComponent(0.8)
        cell.layer.cornerRadius = indexPath.row <= 2 ? 10 : cell.frame.height / 2
        return cell ?? UICollectionViewCell()
    }
    
    
    
    
}
