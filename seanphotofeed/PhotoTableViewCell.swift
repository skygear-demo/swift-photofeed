//
//  PhotoTableViewCell.swift
//  seanphotofeed
//
//  Created by Chin Sean Choo on 11/18/16.
//  Copyright © 2016 SkygearIO. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var loveView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Awake from nib")
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(sender:)))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
        
        loveView.isHidden = true
    }
    
    func doubleTapped(sender: UITapGestureRecognizer) {
        loveView.isHidden = false
        loveView.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.loveView.alpha = 1
        }, completion: { finished in
            UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseInOut, animations: {
                self.loveView.alpha = 0
            }, completion: { finished in
                self.loveView.isHidden = true
            })
        })
    }
    
}
