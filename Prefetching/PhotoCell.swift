//
//  PhotoCell.swift
//  Prefetching
//
//  Created by Ranjit Mahto on 31/03/24.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    func configure(with viewModel: ViewModel) {
        viewModel.downloadImage { downImage in
            if let image = downImage {
                
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
        }
    }
    
}

