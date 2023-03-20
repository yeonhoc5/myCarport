//
//  CarInfoDAO.swift
//  myCarport
//
//  Created by yeonhoc5 on 2023/03/02.
//

import UIKit
import CoreData

class CarInfoDAO {
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - 1. 전체 데이터 로드
    func fetch() -> [CarInfo] {
        var myCarList = [CarInfo]()
        // 1. 요청 객체 생성
        let fetchRequest: NSFetchRequest<CarInfoMO> = CarInfoMO.fetchRequest()
        
        // 2. 정렬 옵션
        
        do {
            let resultSet = try self.context.fetch(fetchRequest)
            // 3. 읽어온 데이터를 CarInfo 타입으로 변환하기
            if resultSet.count > 0 {
                for data in resultSet {
                    var carInfo = CarInfo()
                    carInfo.carName = data.carName ?? ""
                    carInfo.carNumber = data.carNumber ?? ""
                    carInfo.typeFuel = data.typeFuel.toTypeFuel()
                    carInfo.typeShift = data.typeShift.toTypeShift()
                    carInfo.mileage = Int(data.mileage)
                    
                    var insuranceData = data.insurance?.array as! [InsuranceMO]
                    insuranceData = insuranceData.sorted(by: {$0.dateStart! < $1.dateStart!})
                    for ins in insuranceData {
                        var insurace = Insurance()
                        insurace.corpName = ins.corpName
                        insurace.dateStart = ins.dateStart
                        insurace.dateEnd = ins.dateEnd
                        insurace.mileageContract = Int(ins.mileageContract)
                        insurace.payContract = Int(ins.payContract)
                        insurace.callOfCorp = Int(ins.callOfCorp)
                        insurace.objectID = ins.objectID
                        carInfo.insurance.append(insurace)
                    }
                    
                    let maintenanceData = data.maintenance?.array as! [MaintenanceMO]
                    for main in maintenanceData {
                        var maintenance = Maintenance()
                        maintenance.nameOfItem = main.nameOfItem ?? ""
                        maintenance.cycleMileage = Int(main.cycleMileage)
                        maintenance.cyclePeriod = Int(main.cyclePeriod)
                        var historyData = main.manageHistory?.array as! [ManageHistoryMO]
                        historyData = historyData.sorted(by: {$0.changeDate! < $1.changeDate!})
                        for his in historyData {
                            var history = ManageHistory()
                            history.mileage = Int(his.mileage)
                            history.changeDate = his.changeDate ?? Date()
                            history.objectID = his.objectID
                            maintenance.historyManage.append(history)
                        }
                        maintenance.objectID = main.objectID
                        carInfo.maintenance.append(maintenance)
                    }
                    
                    carInfo.objectID = data.objectID
                    myCarList.append(carInfo)
                    
                }
            }
        } catch let e as NSError {
            NSLog("An Error has occured: %s", e.localizedDescription)
        }
        return myCarList
    }
    
    
    // MARK: - 2. 데이터 추가
    // 2-1. 차량 추가
    func addCarList(_ data: CarInfo) -> Bool {
        let object = NSEntityDescription.insertNewObject(forEntityName: "CarInfo", into: context) as! CarInfoMO
        
        object.carName = data.carName
        object.carNumber = data.carNumber
        object.typeFuel = Int16(data.typeFuel.rawValue)
        object.typeShift = Int16(data.typeShift.rawValue)
        object.mileage = Int64(data.mileage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let recommenItemList = object.typeFuel == 0 ? appDelegate.gasolineItemList : appDelegate.dieselItemList
        print(recommenItemList)
        for item in recommenItemList {
            let maintenanceObject = NSEntityDescription.insertNewObject(forEntityName: "Maintenance", into: context) as! MaintenanceMO
            maintenanceObject.nameOfItem = item.0
            maintenanceObject.cycleMileage = Int64(item.1)
            object.addToMaintenance(maintenanceObject)
        }
     
        do {
            try self.context.save()
            
            let dao = CarInfoDAO()
            appDelegate.myCarList = dao.fetch()
            return true
        } catch let e as NSError {
            NSLog("An error has occured: %s", e.localizedDescription)
            return false
        }
        
    }
    // 2-2. 보험 정보 추가
    func addInsuranceTotheCar(_ data: CarInfo, insurance: Insurance) -> Bool {
        let object = NSEntityDescription.insertNewObject(forEntityName: "Insurance", into: context) as! InsuranceMO
        object.corpName = insurance.corpName
        object.dateStart = insurance.dateStart
        object.dateEnd = insurance.dateEnd
        object.payContract = Int64(insurance.payContract)
        object.mileageContract = Int64(insurance.mileageContract)
        
        if let id = data.objectID {
            let carObject = self.context.object(with: id)
            (carObject as! CarInfoMO).addToInsurance(object)
        }
        
        do {
            try self.context.save()

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let dao = CarInfoDAO()
            appDelegate.myCarList = dao.fetch()
            return true
        } catch let e as NSError {
            NSLog("An error has occured: %s", e.localizedDescription)
            return false
        }
    }
    // 2-3. 정비 이력 추가
    func addMaintenanceHistory(maintenanaceID: [NSManagedObjectID], history: ManageHistory) -> Bool {
        maintenanaceID.forEach {
            
            let historyObject = NSEntityDescription.insertNewObject(forEntityName: "ManageHistory", into: context) as! ManageHistoryMO
            historyObject.mileage = Int64(history.mileage)
            historyObject.changeDate = history.changeDate

            let maintenanceObject = self.context.object(with: $0) as! MaintenanceMO
            maintenanceObject.addToManageHistory(historyObject)
        }
        
        do {
            try self.context.save()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myCarList = self.fetch()
            return true
        } catch let e as NSError {
            NSLog("An error has occured: %s", e.localizedDescription)
            return false
        }
    }
    
    
    
    // MARK: - 3. 데이터 삭제
    // 3-1. 차량/보험/정비이력 통합 삭제
    func deleteData(id: NSManagedObjectID) -> Bool {
        let object = self.context.object(with: id)
        self.context.delete(object)
        
        do {
            try self.context.save()
            return true
        } catch let e as NSError {
            NSLog("Error occured during deleting the car", e.localizedDescription)
            return false
        }
    }
    
    
    
    // MARK: - 4. 데이터 수정
    
    // 4-1. 차령 정보 수정
    func modifyCarInfo(carID: NSManagedObjectID, carInfo: CarInfo) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let object = self.context.object(with: carID) as! CarInfoMO
        object.carName = carInfo.carName
        object.carNumber = carInfo.carNumber
        if object.typeFuel != carInfo.typeFuel.rawValue {
            let maintenanceData = object.maintenance?.array as! [MaintenanceMO]
            let itemList = carInfo.typeFuel.rawValue == 0 ? appDelegate.gasolineItemList : appDelegate.dieselItemList
            
            for list in itemList {
                if let item = maintenanceData.filter({$0.nameOfItem == list.0}).first {
                    item.cycleMileage = Int64(list.1)
                }
                
            }
        }
        object.typeFuel = carInfo.typeFuel.rawValue
        object.typeShift = carInfo.typeShift.rawValue
        object.mileage = Int64(carInfo.mileage)
        
        do {
            try self.context.save()
            appDelegate.myCarList = self.fetch()
            return true
        } catch let e as NSError {
            NSLog("Error occured during change car info", e.localizedDescription)
            return false
        }
    }
    // 4-2. 차량 순서 수정
    
    // 4-2. 보험 기록 수정
    func modifyInsuranceInfo(InsuranceID: NSManagedObjectID, insurance: Insurance) -> Bool {
        let object = self.context.object(with: InsuranceID) as! InsuranceMO
        object.corpName = insurance.corpName
        object.callOfCorp = Int64(insurance.callOfCorp ?? 0)
        object.dateStart = insurance.dateStart
        object.dateEnd = insurance.dateEnd
        object.payContract = Int64(insurance.payContract)
        object.mileageContract = Int64(insurance.mileageContract)
        
        do {
            try self.context.save()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myCarList = self.fetch()
            return true
        } catch let e as NSError {
            NSLog("Error occured during modifying insurance Info", e.localizedDescription)
            return false
        }
    }
    // 4-3. 정비 히스토리 수정
    func modifyHistory(historyID: NSManagedObjectID, history: ManageHistory) -> Bool {
        let object = self.context.object(with: historyID) as! ManageHistoryMO
        object.mileage = Int64(history.mileage)
        object.changeDate = history.changeDate
        
        do {
            try self.context.save()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myCarList = self.fetch()
            return true
        } catch let e as NSError {
            NSLog("Error occured during modifying mangeHistory", e.localizedDescription)
            return false
        }
    }
    //  4-4. 주행기록 갱신
    func renewMileage(carID: NSManagedObjectID, mile: Int) -> Bool {
        let object = self.context.object(with: carID)
        (object as! CarInfoMO).mileage = Int64(mile)
        
        do {
            try self.context.save()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myCarList = self.fetch()
            return true
        } catch let e as NSError {
            NSLog("Error occured during renewing Mileas", e.localizedDescription)
            return false
        }
    }
    
}
