//
//  MineCell.swift
//  Minesweeper
//
//  Created by 陳劭任 on 2019/4/20.
//  Copyright © 2019 陳劭任. All rights reserved.
//

import UIKit

class MineCell: UICollectionViewCell {
    
    @IBOutlet weak var mineCountLabel: UILabel!
    
    var mineCount: Int = 0 {
        willSet {
            
            self.mineCountLabel.text = String(newValue)
            
        }
    }
    
    var isSwept = false
    
    
    
}
