//
//  EventSingleCardCollectionViewCell.swift
//  ios-exam
//
//  Created by pharuthapol on 19/7/2567 BE.
//

import UIKit

class EventSingleCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        contentView.clipsToBounds = true
    }
    
}
