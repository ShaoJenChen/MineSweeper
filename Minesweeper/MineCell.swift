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
    
    @IBOutlet weak var mineBackView: UIView!
    
    @IBOutlet weak var mineIcon: UIImageView!
    
    @IBOutlet weak var flagIcon: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.flagIcon.isHidden = true
        
        self.mineIcon.isHidden = true
        
        self.mineBackView.isHidden = true
        
        self.isSwept = false
        
        self.contentView.backgroundColor = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1)
        
    }
    
    var mineCount: Int = 0 {
        willSet {
            
            self.mineCountLabel.text = String(newValue)
            
            self.mineBackView.backgroundColor = MineCell.getBackColor(mineNumber: newValue)
            
        }
    }
    
    var isSwept = false {
        
        didSet {
            
            if self.mineCount > 0 {
                
                self.mineBackView.isHidden = !isSwept

            }
            else if self.mineCount == 0 {
                
                self.contentView.backgroundColor = .darkGray
                
                self.flagIcon.isHidden = true
                
            }
            
        }
        
    }
    
    static func getBackColor(mineNumber: Int) -> UIColor {
        
        switch mineNumber {
        case -1:
            return .black
        case 1:
            return .green
        case 2:
            return .yellow
        case 3:
            return .orange
        case 4:
            return .red
        case let n where n >= 5:
            return .purple
            
        default:
            return .white
        }
        
    }
    
    
}
