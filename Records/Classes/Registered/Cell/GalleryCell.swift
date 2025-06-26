//
//  GalleryCell.swift
//  Records
//
//  Created by MACM72 on 26/06/25.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    static let indetifier = "GalleryCell"
    
    @IBOutlet var imageView:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with image:UIImage){
        imageView.image = image
    }
    
    static func nib()->UINib{
        return UINib(nibName: "GalleryCell", bundle: nil)
    }
}
