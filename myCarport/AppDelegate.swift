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

    var carListSample: [CarInfo] = [
        CarInfo(carName: "라세티", carNumber: "48소9953", typeFuel: .gasoline, typeShift: .Auto, mileage: 128999, maintenance: []),
        CarInfo(carName: "트레일블레이저", carNumber: "000소0000", typeFuel: .diesel, typeShift: .Stick, mileage: 0, maintenance: [])
    ] 
    var itemList = [("에어컨필터", 5000), ("엔진오일", 10000), ("에어필터", 10000), ("오일필터", 10000), ("와이퍼", 10000), ("점화플러그", 30000), ("연료필터", 30000), ("브레이크액", 30000), ("브레이크패드", 40000), ("미션오일", 40000), ("냉각수", 40000), ("파워스티어링 오일", 50000), ("타이어(전)", 50000), ("타이어(후)", 50000), ("구동벨트", 60000),("타이밍벨트", 80000), ("배터리", 100000), ("디퍼런셜 오일", 120000)]

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        itemList.forEach { item in
            for i in 0..<carListSample.count {
                carListSample[i].maintenance.append(Maintenance(nameOfItem: item.0, cycleMileage: item.1))
            }
        }
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

