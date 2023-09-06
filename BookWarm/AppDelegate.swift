//
//  AppDelegate.swift
//  BookWarm
//
//  Created by JongHoon on 2023/07/31.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = .label
        UITabBar.appearance().tintColor = .label
        
//        print("✨✨✨", Realm.Configuration().schemaVersion, "✨✨✨")
        
        let config = Realm.Configuration(
            schemaVersion: 6,
            migrationBlock: { migration, oldSchemaVersion in
                
                // BookTable isStar Column 추가
                if oldSchemaVersion < 1 { }
                
                // BookTable isStar Column 삭제
                if oldSchemaVersion < 2 { }
                
                // BookTable column명 변경 memo => bookMemo
                if oldSchemaVersion < 3 {
                    migration.renameProperty(
                        onType: BookTable.className(),
                        from: "memo",
                        to: "bookMemo"
                    )
                }
                
                // BookTable bookSummary column 추가(title + summary)
                if oldSchemaVersion < 4 {
                    migration.enumerateObjects(
                        ofType: BookTable.className(), { oldObject, newObject in
                            guard let new = newObject else { return }
                            guard let old = oldObject else { return }
                            new["bookSummary"] = "제목: \(old["title"] ?? ""), 메모: \(old["bookMemo"] ?? "")"
                        }
                    )
                }
                
                // BookTable count column 추가(기본값 지정 필요)
                if oldSchemaVersion < 5 {
                    migration.enumerateObjects(
                        ofType: BookTable.className(), { _, newObject in
                            guard let new = newObject else { return }
                            new["count"] = 99
                        }
                    )
                }
                
                // BookTable count column 타입 변경(Int -> String)
                if oldSchemaVersion < 6 {
                    migration.enumerateObjects(
                        ofType: BookTable.className(), { oldObject, newObject in
                            guard let new = newObject else { return }
                            guard let old = oldObject else { return }
                            
                            new["count"] = "\(old["count"] ?? 0)"
                        })
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        
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


}

