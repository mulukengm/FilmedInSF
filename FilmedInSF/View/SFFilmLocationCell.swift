//
//  SFFilmLocationCell.swift
//  FilmedInSF
//
//  Created by Muluken Gebremariam on 2/18/18.
//  Copyright © 2018 Muluken Gebremariam. All rights reserved.
//

import UIKit

class SFFilmLocationCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        movieTitleLabel.text = nil;
        releaseYearLabel.text = nil;
        movieTitleLabel.text = nil;
    }
}
