//
//  HomeViewController.swift
//  Tripper
//
//  Created by Pinghsien Lin on 12/9/16.
//  Copyright © 2016 vudu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import EventKit
import BRYXBanner

// blue - UIColor(red:66.00/255.0, green:165.0/255.0, blue:245/255.0, alpha:1.000)
// purple - UIColor(red:165.00/255.0, green:101.0/255.0, blue:249/255.0, alpha:1.000)

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sfoCV: UICollectionView!
    @IBOutlet weak var nrtCV: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var needPermissionView: UIView!

    let contents: [JSON]
    let sfo: [JSON]
    let nrt: [JSON]
    let cdg: [JSON]
    let eventStore = EKEventStore()
    var events: [EKEvent]?
    
    required init?(coder aDecoder: NSCoder) {
        if let arr = getJson("sfo")?.array {
            self.contents = arr
        } else {
            self.contents = []
        }
        if let sfo = getJson("sfo")?.array {
            self.sfo = sfo
        } else {
            self.sfo = []
        }
        if let nrt = getJson("nrt")?.array {
            self.nrt = nrt
        } else {
            self.nrt = []
        }
        if let cdg = getJson("cdg")?.array {
            self.cdg = cdg
        } else {
            self.cdg = []
        }
        super.init(coder: aDecoder)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        searchBar.resignFirstResponder()
//        self.searchBar.backgroundColor = .white
        
//        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.backgroundImage = UIImage(named: "search_bg")
        
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.layer.borderWidth = 0
        textFieldInsideSearchBar?.layer.borderColor = UIColor.clear.cgColor
        textFieldInsideSearchBar?.background = nil
        textFieldInsideSearchBar?.borderStyle = .none
        
        
        textFieldInsideSearchBar?.textColor = .black
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = .gray
        
        
        let s = self.scrollView.bounds.size
        self.scrollView.contentSize = CGSize(width: s.width, height: 800.0)
        checkCalendarAuthorizationStatus()
        setupNotificationSettings()

        self.searchBar.setImage(UIImage(named:"search"), for: .search, state: .normal)
        
        
//        _searchBar = [[UISearchBar alloc]init];
//        self.searchBar.backgroundColor = .white
        
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        


    }
    
    @IBAction func seeAllSFO(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
        vc.setData(city: .sfo)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func seeAllNRT(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
        vc.setData(city: .nrt)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func seeAllCDG(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
        vc.setData(city: .cdg)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "sfo" {
            return self.sfo.count
        } else  if collectionView.restorationIdentifier == "nrt" {
            return self.nrt.count
        } else  if collectionView.restorationIdentifier == "cdg" {
            return self.cdg.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VVCell", for: indexPath) as? VVCollectionViewCell else {
            fatalError("no cell")
        }
        if collectionView.restorationIdentifier == "sfo" {
            if let img = self.sfo[indexPath.item]["scenes"][0].string {
                cell.setImage("\(img).jpg")
            }
            if let title = self.sfo[indexPath.item]["title"].string {
                cell.setTitle(title: title)
            }
            
        } else  if collectionView.restorationIdentifier == "nrt" {
            if let img = self.nrt[indexPath.item]["scenes"][0].string {
                cell.setImage("\(img).jpg")
            }
            if let title = self.nrt[indexPath.item]["title"].string {
                cell.setTitle(title: title)
            }
        } else  if collectionView.restorationIdentifier == "cdg" {
            if let img = self.cdg[indexPath.item]["scenes"][0].string {
                cell.setImage("\(img).jpg")
            }
            if let title = self.cdg[indexPath.item]["title"].string {
                cell.setTitle(title: title)
            }
        }
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
// MARK - Calendar
    
    
    @IBAction func secretGoldenGateEventTap() {
        print("user taps GG secret event btn")
        
        var ggJson: JSON? = nil
        
        let banner = Banner(title: "Around Golden Gate Bridge?", subtitle: "Do you know Godzilla was shot here?", image: UIImage(named: "dropPin"), backgroundColor: UIColor(red:190.00/255.0, green:101.0/255.0, blue:249/255.0, alpha:1.00))
        
        for j in self.sfo {
            if let cid = j["contentId"].string, cid == "534815" {
                ggJson = j
            }
        }
        banner.didTapBlock = {
            
            if let c = ggJson {
                let vc = DetailViewController()
                vc.allowedDismissDirection = .bottom
                vc.directionLock = true
                vc.maskType = .black
                vc.content = c
                //            vc.ind = indexPath.item
                
                vc.showInteractive()
            }
        }
        banner.dismissesOnTap = true
        banner.show(duration: 5.0)
    }
    
    
    @IBAction func secretSFEventTap() {
        print("user taps SF secret event btn")
        let banner = Banner(title: "Around San Francisco?", subtitle: "Interested in movies that were shot here?", image: UIImage(named: "dropPin"), backgroundColor: UIColor(red:190.00/255.0, green:101.0/255.0, blue:249/255.0, alpha:1.00))
        banner.didTapBlock = {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
            vc.setData(city: .sfo)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        banner.dismissesOnTap = true
        banner.show(duration: 5.0)
    }
    
    @IBAction func secretJPEventTap() {
        // create a corresponding local notification
        print("user taps JP secret event btn")
        let notification = UILocalNotification()
        notification.alertBody = "Traveling to Tokyo? Would you be interested checking out movies that were shot there? "
        notification.alertAction = "Yes, take me to Tripper"
        notification.fireDate = NSDate(timeIntervalSinceNow: +10) as Date
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["action": "JP"]
        notification.category = "tripperCategory"
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            loadCalendars()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            needPermissionView.isHidden = false
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.needPermissionView.isHidden = false
                })
            }
        })
    }
    
    func loadCalendars() {
        let calendars = eventStore.calendars(for: EKEntityType.event)
        
        for calendar in calendars {
            if calendar.title == "Calendar" {
                
                let now = Date()
                let oneWeekAfter = NSDate(timeIntervalSinceNow: +8*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: now, end: oneWeekAfter as Date, calendars: [calendar])
                
                self.events = eventStore.events(matching: predicate)
//                print(self.events)
            }
        }
    }
    
    func setupNotificationSettings() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.shared.currentUserNotificationSettings
        
        if (notificationSettings.types == UIUserNotificationType.alert){
            // Specify the notification types.
            var notificationTypes: UIUserNotificationType = UIUserNotificationType.alert
            
            var gotoTripperAction = UIMutableUserNotificationAction()
            gotoTripperAction.identifier = "toTripper"
            gotoTripperAction.title = "Check it out"
            gotoTripperAction.activationMode = UIUserNotificationActivationMode.foreground
            gotoTripperAction.isDestructive = false
            gotoTripperAction.isAuthenticationRequired = true
            
            // Specify the category related to the above actions.
            var tripperCategory = UIMutableUserNotificationCategory()
            tripperCategory.identifier = "tripperCategory"
            tripperCategory.setActions([gotoTripperAction], for: UIUserNotificationActionContext.default)
            tripperCategory.setActions([gotoTripperAction], for: UIUserNotificationActionContext.minimal)
            
            
            let categoriesForSettings = NSSet(objects: tripperCategory)
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: categoriesForSettings as! Set<UIUserNotificationCategory>)
            UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
        }
    }

    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if searchBar.text?.lowercased() == "sfo" || searchBar.text?.lowercased() == "san francisco" {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
                vc.setData(city: .sfo)
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else if searchBar.text?.lowercased() == "nrt" || searchBar.text?.lowercased() == "tokyo" {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
                vc.setData(city: .nrt)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
            vc.setData(city: .cdg)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        searchBar.text = ""
        
    }
}
