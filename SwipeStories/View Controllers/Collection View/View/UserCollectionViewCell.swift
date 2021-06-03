//
//  UserCollectionViewCell.swift
//  SwipeStories
//
//  Created by Mayur Susare on 02/06/21.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserCollectionViewCell"
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    //MARK:- Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblUserName.textAlignment = .left
        self.imgView.layer.cornerRadius = self.imgView.frame.size.height / 2;
        self.imgView.layer.borderColor = UIColor.red.cgColor
        self.imgView.layer.borderWidth = 3
        self.imgView.clipsToBounds = true
    }
}
