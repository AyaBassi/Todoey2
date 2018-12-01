//
//  AppDelegate.swift
//  Todoey2
//
//  Created by Aya Bassi on 12/09/2018.
//  Copyright © 2018 Green Balloons. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //  print(Realm.Configuration.defaultConfiguration.fileURL)
       
        

        do{
            _ = try Realm()
            
        } catch{
            print("Error initilising new Realm \(error)")
        }
        return true
    }



}

