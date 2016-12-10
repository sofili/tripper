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
    
    var content: JSON?
    var ind: Int = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.content?["title"].stringValue
        self.imageView.image = UIImage(named: "t\(self.ind + 1).jpg")
        
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
    
}
