//
//  ViewController.swift
//  Tripper
//
//  Created by Pinghsien Lin on 11/22/16.
//  Copyright © 2016 vudu. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

enum City: String {
    case sfo = "sfo"
    case nrt = "nrt"
    case cdg = "cdg"
}

class MapViewController: UIViewController, GMSMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var mapView: GMSMapView!
    var city: City!
    
    var contents: [JSON]! = nil
    
    var collectionViewContent: JSON? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setData(city: City) {
        self.city = city
        if let arr = getJson(city.rawValue)?.array {
            self.contents = arr
            //            self.collectionViewContent = arr[0]
        } else {
            self.contents = []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default SFO
        var camera = GMSCameraPosition.camera(withLatitude: 37.806592, longitude: -122.4452370, zoom: 12.0)
        if city == City.nrt {
            camera = GMSCameraPosition.camera(withLatitude: 36.245659, longitude: 137.5210113, zoom: 6.0)
        } else if city == City.cdg {
            camera = GMSCameraPosition.camera(withLatitude: 35.6668861, longitude: 139.6751166, zoom: 12.0)
        }
        
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        self.mapView.isMyLocationEnabled = true
        
        
        
        self.view.insertSubview(mapView, at: 0)

        
        self.mapView.delegate = self
        self.createMarker()
        self.collectionViewFlowLayout.itemSize = self.collectionView.frame.size
//        self.collectionView.isPagingEnabled = true
//        self.collectionViewFlowLayout.minimumInteritemSpacing = 0;
//        self.collectionViewFlowLayout.minimumLineSpacing = 0;
        
        
        self.collectionView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionViewFlowLayout.itemSize = self.collectionView.frame.size
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    private func createMarker() {

        _ = self.contents.map { a in
            let marker = GMSMarker()
            print(a)
            marker.userData = a
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(a["latitude"].floatValue), longitude: CLLocationDegrees(a["longitude"].floatValue))
            marker.title = a["title"].stringValue
            marker.snippet = a["snippet"].stringValue
            marker.appearAnimation = kGMSMarkerAnimationPop
            
            marker.icon = UIImage(named: "dropin")
            marker.map = self.mapView
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let content = marker.userData as? JSON else {
            print("no userData")
            return false
        }
        self.collectionView.isHidden = false
        self.collectionViewContent = content
//        print(content)
        self.collectionView.reloadData()
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.collectionViewContent?["scenes"].arrayValue.count)
        return self.collectionViewContent?["scenes"].arrayValue.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VVCell", for: indexPath) as? VVCollectionViewCell else {
            fatalError("no cell")
        }
        guard let scenes = self.collectionViewContent?["scenes"].array else {
            print("collectionViewContent not set yet.")
            return cell
        }
        if scenes.count >= indexPath.item {
            print("\(scenes[indexPath.item].stringValue).jpg")
            cell.setImage("\(scenes[indexPath.item].stringValue).jpg")
            cell.titleLabel?.text = self.collectionViewContent?["title"].stringValue
            cell.genreLabel?.text = (self.collectionViewContent?["genre"].stringValue)! + " | " + (self.collectionViewContent?["year"].stringValue)!
        }
//        print(indexPath.item)
//        cell.setImage(indexPath.item)
        
        return cell
        
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let content = self.contents[indexPath.item]
        
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            
            vc.allowedDismissDirection = .bottom
            vc.directionLock = true
            vc.maskType = .black
            vc.content = content
            vc.ind = indexPath.item
            print("====\(vc.titleLabel)")
//            vc.titleLabel.text = content["title"].stringValue
//            vc.imageView.image = UIImage(named: "t\(indexPath.item + 1).jpg")
            
//            
//            
            
            vc.showInteractive()
        }
    }

}

