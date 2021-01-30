//
//  TripCollectionViewCell.swift
//  09CarouselApp
//
//  Created by Daria Eremina on 30.01.2021.
//

import UIKit

protocol TripCollectionCellDelegate {
    func didLikeButtonPressed(cell: TripCollectionViewCell)
}

class TripCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var totalDaysLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    var delegate:TripCollectionCellDelegate?
    @IBAction func likeButtonTapped(sender: AnyObject) { delegate?.didLikeButtonPressed(cell: self)
    }
    
    
    var isLiked:Bool = false {
        didSet {
            if isLiked {
                likeButton.setImage(UIImage(named: "heartfull"), for: .normal)
            }
            else {
                likeButton.setImage(UIImage(named: "heart"), for: .normal)
            }
        }
    }
}
