//
//  AppDelegate.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/01.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var sampleCar = CarInfo(carName: "샘플", carNumber: "123가4567", typeFuel: .gasoline, typeShift: .auto, mileage: 32000, insurance: [], maintenance: [])
    var sampleInsurance = [Insurance(corpName: " ⃝ ⃝ 다이렉트", dateStart: Date().addingTimeInterval(-(365 * 24 * 3600) * 2), dateEnd: Date().addingTimeInterval(-(366 * 24 * 3600)),
                                      payContract: 950000, mileageContract: 35000, callOfCorp: 56785678),
                           Insurance(corpName: " ⃝ ⃝ 보험", dateStart: Date().addingTimeInterval(-(365 * 24 * 3600)), dateEnd: Date().addingTimeInterval(-24 * 3600),
                                      payContract: 800000, mileageContract: 51000, callOfCorp: 12341234),
                           Insurance(corpName: " ⃝ ⃝ 화재 보험", dateStart: Date(), dateEnd: Date().addingTimeInterval(365 * 24 * 3600),
                                      payContract: 750000, mileageContract: 70000, callOfCorp: 12345678)]
    
    var sampleHistory = [ManageHistory(mileage: 1200, changeDate: Date().addingTimeInterval(-(500 * 24 * 3600))),
                         ManageHistory(mileage: 1500, changeDate: Date().addingTimeInterval(-(400 * 24 * 3600))),
                         ManageHistory(mileage: 4000, changeDate: Date().addingTimeInterval(-(300 * 24 * 3600))),
                         ManageHistory(mileage: 8200, changeDate: Date().addingTimeInterval(-(200 * 24 * 3600))),
                         ManageHistory(mileage: 12200, changeDate: Date().addingTimeInterval(-(100 * 24 * 3600))),
                         ManageHistory(mileage: 20100, changeDate: Date())]
    
    var gasolineItemList = [("에어컨필터", 5000), ("엔진오일", 10000), ("에어필터", 10000), ("오일필터", 10000), ("와이퍼", 10000),
                            ("점화플러그", 30000), ("연료필터", 60000), ("브레이크액", 30000), ("브레이크패드", 40000), ("미션오일", 40000),
                            ("냉각수", 40000), ("파워스티어링 오일", 50000), ("타이어(전)", 50000), ("타이어(후)", 50000), ("구동벨트", 60000),
                            ("타이밍벨트", 80000), ("배터리", 100000), ("디퍼런셜 오일", 120000)]
    
    var dieselItemList = [("에어컨필터", 5000), ("엔진오일", 10000), ("에어필터", 10000), ("오일필터", 10000), ("와이퍼", 10000),
                          ("점화플러그", 30000), ("연료필터", 30000), ("브레이크액", 30000), ("브레이크패드", 40000), ("미션오일", 40000),
                          ("냉각수", 40000), ("파워스티어링 오일", 50000), ("타이어(전)", 50000), ("타이어(후)", 50000), ("구동벨트", 60000),
                          ("타이밍벨트", 80000), ("배터리", 100000), ("디퍼런셜 오일", 120000)]
    
    var tempGraphArray = Array(1...20).shuffled()
    
    var insuranceCorp: [InsuranceCorp] = [InsuranceCorp(name: "AXA손해보험", logo: "axa", callNumber: 15662266),
                                          InsuranceCorp(name: "DB손해보험", logo: "db", callNumber: 15880100),
                                          InsuranceCorp(name: "KB손해보험", logo: "kb", callNumber: 15440114),
                                          InsuranceCorp(name: "MG손해보험", logo: "mg", callNumber: 15885959),
                                          InsuranceCorp(name: "롯데손해보험", logo: "lotte", callNumber: 15883344),
                                          InsuranceCorp(name: "메리츠화재", logo: "meritz", callNumber: 15665000),
                                          InsuranceCorp(name: "삼성화재", logo: "samsung", callNumber: 15885114),
                                          InsuranceCorp(name: "캐롯손해보험", logo: "carrot", callNumber: 15660300),
                                          InsuranceCorp(name: "하나손해보험", logo: "hana", callNumber: 16443633),
                                          InsuranceCorp(name: "한화손해보험", logo: "hanhwa", callNumber: 15668000),
                                          InsuranceCorp(name: "현대해상", logo: "hyundai", callNumber: 15885656),
                                          InsuranceCorp(name: "흥국화재", logo: "heungkuk", callNumber: 16881688)
    ]
                                          
    
    var insuranceSite = [
        "https://m.idbins.com/FMMAIV0001.do",
    ]
    var myCarList: [CarInfo] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.5)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "myCarport")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

