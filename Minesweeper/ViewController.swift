//
//  ViewController.swift
//  Minesweeper
//
//  Created by 陳劭任 on 2019/4/20.
//  Copyright © 2019 陳劭任. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dimesional = 10
    
    var minesweeperArray: [[Int]]!
    
    @IBOutlet weak var minesColletcionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createRandomMinesArray()
        
    }

    private func createRandomMinesArray() {
        
        //採地雷
        var bombCount = Int.random(in: 1 ... (dimesional * dimesional)/2 )
        
        //1.產生內容全部為零的二維陣列
       minesweeperArray  = createZeroArray(with: dimesional)
        
        //2.隨機挑選地雷座標，並將地雷數值填入
        while bombCount > 0 {
            
            var coordinate = getBombCoordinate()
            
            while minesweeperArray[coordinate.0][coordinate.1] == -1 {
                
                coordinate = getBombCoordinate()
            }
            
            minesweeperArray[coordinate.0][coordinate.1] = -1
            
            bombCount -= 1
            
        }
        
        //3.輪巡二維陣列
        for rowIndex in 0 ..< minesweeperArray.count {
            
            for columnIndex in  0 ..< minesweeperArray[rowIndex].count {
                
                if minesweeperArray[rowIndex][columnIndex] == 0 {
                    
                    let sum = countingBombSummary(row: rowIndex, column: columnIndex)
                    
                    minesweeperArray[rowIndex][columnIndex] = sum
                    
                }
                
            }
            
        }
        
        //4.印出結果陣列
        print()
        for rowIndex in 0..<minesweeperArray.count
        {
            for columnIndex in  0..<minesweeperArray[ rowIndex ].count
            {
                let v = minesweeperArray[ rowIndex ][ columnIndex ]
                print("\(v>=0 ? " ":"")\(v) " , terminator:"")
            }
            print()
        }
        
        print()

    }
    
    private func createZeroArray(with dimesional: Int) -> [[Int]] {
        
        let zeroArray = Array(repeating: Array(repeating: 0, count: dimesional), count: dimesional)
        
        return zeroArray
        
    }
    
    private func getBombCoordinate() -> (Int,Int) {
        
        let bombColumn = Int.random(in: 0 ..< dimesional)
        
        let bombRow = Int.random(in: 0 ..< dimesional)
        
        return (bombColumn, bombRow)
        
    }
    
    private func countingBombSummary(row: Int, column: Int ) -> Int {
        
        var bombCount = 0
        
        let leftTop = (row - 1, column - 1)
        let top = (row - 1, column)
        let rightTop = (row - 1, column + 1)
        
        let left = (row, column - 1)
        let right = (row, column + 1)
        
        let leftDown = (row + 1, column - 1)
        let down = (row + 1, column)
        let rightDown = (row + 1, column + 1)
        
        let eightPositions = [leftTop, top, rightTop, left, right, leftDown, down, rightDown]
        
        for (row, column) in eightPositions {
            
            if row >= 0 && row < dimesional
                && column >= 0 && column < dimesional {
                
                if minesweeperArray[row][column] == -1 {
                    
                    bombCount += 1
                    
                }
                
            }
            
        }
        
        return bombCount
        
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dimesional * self.dimesional
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineCell", for: indexPath) as? MineCell {
            
            let row = indexPath.row / self.dimesional
            
            let column = indexPath.row - (self.dimesional * row)
            
            cell.mineCount = self.minesweeperArray[row][column]
            
            return cell
            
        }
    
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.width / 10
        
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        
        return cellSize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}
