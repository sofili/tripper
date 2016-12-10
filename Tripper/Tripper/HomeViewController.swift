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
class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sfoCV: UICollectionView!
    @IBOutlet weak var nrtCV: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    let contents: [JSON]
    let sfo: [JSON]
    let nrt: [JSON]
    let cdg: [JSON]
    
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
        self.scrollView.contentSize = CGSize(width: s.width, height: 900.0)
        self.searchBar.setImage(UIImage(named:"search"), for: .search, state: .normal)
        
        
//        _searchBar = [[UISearchBar alloc]init];
//        self.searchBar.backgroundColor = .white
        
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        


    }
    
    @IBAction func seeAllSFO(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func seeAllNRT(_ sender: UIButton) {
    }
    @IBAction func seeAllCDG(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
        
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
        } else  if collectionView.restorationIdentifier == "nrt" {
            if let img = self.nrt[indexPath.item]["scenes"][0].string {
                
                cell.setImage("\(img).jpg")
            }
        } else  if collectionView.restorationIdentifier == "cdg" {
            if let img = self.cdg[indexPath.item]["scenes"][0].string {
                cell.setImage("\(img).jpg")
            }
        }
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if searchBar.text?.lowercased() == "sfo" || searchBar.text?.lowercased() == "san francisco" {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else if searchBar.text?.lowercased() == "nrt" || searchBar.text?.lowercased() == "tokyo" {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
        searchBar.text = ""
        
    }
}
