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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ava1: UIImageView!
    @IBOutlet weak var ava2: UIImageView!
    @IBOutlet weak var ava3: UIImageView!
    @IBOutlet weak var ava4: UIImageView!
    @IBOutlet weak var ava5: UIImageView!
    
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
    }
    
    @IBAction func tapToVUDU() {
        if let url = URL(string: "http://www.vudu.com/movies/#!content/12579/The-Rock") {
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension UIImageView {
    func makeAvatar() {
        self.layoutIfNeeded()
        layer.cornerRadius = self.frame.height / 2.0
        layer.masksToBounds = true
    }
    
}
