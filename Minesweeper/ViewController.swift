//
//  ViewController.swift
//  Minesweeper
//
//  Created by 陳劭任 on 2019/4/20.
//  Copyright © 2019 陳劭任. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dimesional = 8
    
    var minesweeperArray: [[Int]]!
    
    var totlaMineNumber = 0
    
    @IBOutlet weak var minesColletcionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createNewGame()
        
        self.addLongPressGesture()
        
    }
    
    private func createNewGame() {
        
        self.createRandomMinesArray()
        
    }
    
    
    private func createRandomMinesArray() {
        
        //random mineCount
        var randomMineNumber = Int.random(in: (dimesional * dimesional)/10 ... (dimesional * dimesional)/4 )
//        var randomMineNumber = Int.random(in: 5 ... 15)
        
        self.totlaMineNumber = randomMineNumber
        
        //1.產生內容全部為零的二維陣列
        minesweeperArray  = createZeroArray(with: dimesional)
        
        //2.隨機挑選地雷座標，並將地雷數值填入
        while randomMineNumber > 0 {
            
            var coordinate = randomMineCoordinate()
            
            while minesweeperArray[coordinate.0][coordinate.1] == -1 {
                
                coordinate = randomMineCoordinate()
            }
            
            minesweeperArray[coordinate.0][coordinate.1] = -1
            
            randomMineNumber -= 1
            
        }
        
        //3.輪巡二維陣列
        for rowIndex in 0 ..< minesweeperArray.count {
            
            for columnIndex in  0 ..< minesweeperArray[rowIndex].count {
                
                if minesweeperArray[rowIndex][columnIndex] == 0 {
                    
                    let sum = summaryMine(row: rowIndex, column: columnIndex)
                    
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
    
    private func addLongPressGesture() {
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        
        self.minesColletcionView.addGestureRecognizer(gesture)
        
    }
    
    private func createZeroArray(with dimesional: Int) -> [[Int]] {
        
        let zeroArray = Array(repeating: Array(repeating: 0, count: dimesional), count: dimesional)
        
        return zeroArray
        
    }
    
    private func randomMineCoordinate() -> (Int,Int) {
        
        let column = Int.random(in: 0 ..< dimesional)
        
        let row = Int.random(in: 0 ..< dimesional)
        
        return (column, row)
        
    }
    
    private func summaryMine(row: Int, column: Int ) -> Int {
        
        var mineCount = 0
        
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
                    
                    mineCount += 1
                    
                }
                
            }
            
        }
        
        return mineCount
        
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
            
            // add a border
            cell.layer.borderColor = UIColor.black.cgColor
            
            cell.layer.borderWidth = 1
            
            cell.backgroundColor = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1)
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.width / CGFloat(dimesional)
        
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


extension ViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tapCoordinate = Coordinate(indexPath: indexPath, globalDimesional: self.dimesional)
        
        let mineCount = self.minesweeperArray[tapCoordinate.row!][tapCoordinate.column!]
        
        if mineCount >= 0 {
            
            self.mineSweep(collectionView, coordinate: tapCoordinate)
            
            self.checkSweep()
            
            return
            
        }
        
        //點到炸彈
        guard let cell = collectionView.cellForItem(at: indexPath) as? MineCell else { return }
        
        cell.mineIcon.isHidden = false
        
        self.presentAlert(titile: "點到炸彈", message: "再玩一次嗎?")
        
    }
    
    //handleLongPress
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        
        if gesture.state == .ended { return }
        
        if gesture.state == .cancelled { return }
        
        if gesture.state == .changed { return }
        
        let p = gesture.location(in: self.minesColletcionView)
        
        if let indexPath = self.minesColletcionView.indexPathForItem(at: p) {
            
            guard let cell = self.minesColletcionView.cellForItem(at: indexPath) as? MineCell else { return }
            
            if !cell.isSwept {
                
                cell.flagIcon.isHidden.toggle()
                
            }
            
        }
        
    }
    
    private func presentAlert(titile: String, message: String) {
        
        let alert = UIAlertController(title: titile, message: message, preferredStyle: .alert)
        
        let action_OK = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            self.createNewGame()
            
            self.minesColletcionView.reloadData()
            
        }
        
        let action_cancel = UIAlertAction(title: "No", style: .cancel) { (action) in
            
            self.minesColletcionView.isUserInteractionEnabled = false
            
        }
        
        alert.addAction(action_OK)
        
        alert.addAction(action_cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: Minesweep
extension ViewController {
    
    private func mineSweep(_ collectionView: UICollectionView, coordinate: Coordinate, fromIndexPath: IndexPath? = nil) {
        
        guard let cell = collectionView.cellForItem(at: coordinate.indexPath!) as? MineCell else { return }
        
        guard cell.isSwept == false else { return }
        
        guard let row = coordinate.row,
            0 ..< self.dimesional ~= row else { return }
        
        guard let column = coordinate.column,
            0 ..< self.dimesional ~= column else { return }
        
        cell.isSwept.toggle()
        
        let myMineCount = self.minesweeperArray[row][column]
        
        if myMineCount > 0 { return }
        
        if myMineCount == 0 {
            
            cell.layer.borderWidth = 0
            
            cell.mineBackView.backgroundColor = .darkGray
            
        }
        
        let leftTop = Coordinate(row: row - 1, column: column - 1, globalDimesional: self.dimesional)
        
        let top = Coordinate(row: row - 1, column: column, globalDimesional: self.dimesional)
        
        let rightTop = Coordinate(row: row - 1, column: column + 1, globalDimesional: self.dimesional)
        
        let left = Coordinate(row: row, column: column - 1, globalDimesional: self.dimesional)
        
        let right = Coordinate(row: row, column: column + 1, globalDimesional: self.dimesional)
        
        let leftBottom = Coordinate(row: row + 1, column: column - 1, globalDimesional: self.dimesional)
        
        let bottom = Coordinate(row: row + 1, column: column, globalDimesional: self.dimesional)
        
        let rightBottom = Coordinate(row: row + 1, column: column + 1, globalDimesional: self.dimesional)
        
        let surroundCoordinates = [leftTop, top, rightTop, left, right, leftBottom, bottom, rightBottom]
        
        if let fromIndexPath = fromIndexPath {
            
            let fromCoordinate = Coordinate(indexPath: fromIndexPath, globalDimesional: self.dimesional)
            
            for surroundCoordinate in surroundCoordinates {
                
                if surroundCoordinate == fromCoordinate {
                    
                    continue
                    
                }
                
                self.mineSweep(collectionView, coordinate: surroundCoordinate, fromIndexPath: coordinate.indexPath!)
                
            }
            
        }
        else {
            
            for surroundCoordinate in surroundCoordinates {
                
                self.mineSweep(collectionView, coordinate: surroundCoordinate, fromIndexPath: coordinate.indexPath!)
                
            }
            
        }
        
    }
    
    func checkSweep() {
        
        var sweptCount = 0
        
        let indexPaths = self.minesColletcionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            
            guard let cell = self.minesColletcionView.cellForItem(at: indexPath) as? MineCell else { return }
            
            if cell.isSwept {
                
                sweptCount += 1
                
            }
            
        }
        
        let isOverCount = (dimesional * dimesional) - self.totlaMineNumber
        
        if sweptCount == isOverCount {
            
            self.presentAlert(titile: "恭喜過關!!", message: "再玩一次嗎？")
            
        }
        
        
    }
    
    struct Coordinate: Equatable {
        
        var row: Int?
        
        var column: Int?
        
        var indexPath: IndexPath?
        
        init(indexPath: IndexPath, globalDimesional: Int) {
            
            self.row = indexPath.row / globalDimesional
            
            self.column = indexPath.row - (globalDimesional * self.row!)
            
            self.indexPath = indexPath
            
        }
        
        init(row: Int, column: Int, globalDimesional: Int) {
            
            self.row = row
            
            self.column = column
            
            self.indexPath = IndexPath(row: row * globalDimesional + column, section: 0)
            
        }
        
    }
    
}
