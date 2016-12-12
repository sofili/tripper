//
//  DetailViewController.swift
//  Tripper
//
//  Created by Pinghsien Lin on 12/1/16.
//  Copyright © 2016 vudu. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: InteractiveViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var generLbl: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var synopsisLbl: UILabel!
    @IBOutlet weak var ava1: UIImageView!
    @IBOutlet weak var ava2: UIImageView!
    @IBOutlet weak var ava3: UIImageView!
    @IBOutlet weak var ava4: UIImageView!
    @IBOutlet weak var ava5: UIImageView!
    @IBOutlet weak var ava6: UIImageView!
    
    var content: JSON?
    var ind: Int = 0
    
    
    convenience init() {
        self.init(nibName: "DetailViewController", bundle: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        batchUpdateAvatar()
        self.titleLabel.text = self.content?["title"].stringValue
//        self.imageView.image = UIImage(named: "t\(self.ind + 1).jpg")
        
        if let imageFileName = content?["scenes"][0].string {
            imageView.image =  UIImage(named: "\(imageFileName).jpg")
        }
        
        // Set poster
        // http://images2.vudu.com/poster2/12579-l
        if let posterName = content?["contentId"].stringValue {
            posterImageView.image = UIImage(named: "\(posterName)-l.jpg")
        }
        
        if let gener = content?["genre"].string {
            generLbl.text = gener
        }
        
        if let synopsis = content?["synopsis"].string {
            synopsisLbl.text = synopsis
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    fileprivate func batchUpdateAvatar() {
        ava1.makeAvatar()
        ava2.makeAvatar()
        ava3.makeAvatar()
        ava4.makeAvatar()
        ava5.makeAvatar()
        ava6.makeAvatar()
    }
    
    @IBAction func tapToVUDU() {
        guard let urlStr = content?["vuduurl"].string else {
            return
        }
        if let url = URL(string: urlStr) {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
}


extension UIImageView {
    func makeAvatar() {
        self.layoutIfNeeded()
        layer.cornerRadius = self.frame.height / 2.0
        layer.masksToBounds = true
    }
    
}
