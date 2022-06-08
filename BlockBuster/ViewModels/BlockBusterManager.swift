//
//  BlockBusterManager.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/7/21.
//

import Foundation
import SwiftUI

class BlockBusterManager : ObservableObject {
    @Published var blocks : [[Block]] = []
    @Published var settings = Settings.standard
    @Published var gameOver : Bool = false
    @Published var highScoreModel = HighScoreModel()
    
    @Published var levelOver : Bool = false
    @Published var levelOverlInfo: String = ""
    @Published var timeLabel : String = ""
    
    // survival game variables
    var timer: Timer?
    var levelTimer: Timer?
    var fallingBlock: Block?
    
    //current game params
    var gameMode : GameMode = .classic
    var blockSize: Int = 30
    var score : Int = 0
    
    // extra params for survival game
    var tcols = 0
    var trows = 0
    var offset = 0
    var speed : Double = 1.0
    var levels = 0
    var currentLevel = 0
    var timeLeft = 0
    
    
    //MARK: functions called by user interactions
    // prepares new game in classic mode
    func initClassicGame(height : Int, width : Int){
        var randomColor : Color = Color.white
        var gameBlocks : [[Block]] = []
        let maxLength = (height < width) ? height : width
        let tempSize = Double(maxLength) * 0.9 / Double(settings.num_blocks)
        
        //set current game params
        gameMode = .classic
        gameOver = false
        blockSize = Int(floor(tempSize))
        score = 0
        //create array of blocks (size depends on setting)
        for i  in 0..<settings.num_blocks {
            var row : [Block] = []
            for j in 0..<settings.num_blocks {
                randomColor = getRandomColor()
                row.append(Block(size: blockSize, color: randomColor, row: i, column: j, toDelete: false, deleted: false, sameColorNeighbors: []))
            }
            gameBlocks.append(row)
        }
        blocks = gameBlocks
        // find same color neighbors for each block
        populatesameColorNeighbors()
    }

    // prepares new game in survival mode
    func initSurvivalGame(height : Int, width : Int){
        //set survival mode params
        tcols = settings.n_cols
        trows = settings.n_rows
        offset = settings.n_rows - settings.n_cols
        speed = settings.speed
        levels = settings.levels
        
        let size1 = Double(height - 220) / Double (trows)
        let size2 = Double(width) / Double (tcols)
        let tempSize = (size1 < size2) ? size1 : size2
        
        //set current game params
        gameMode = .survival
        gameOver = false
        blockSize = Int(floor(tempSize))
        score = 0
        currentLevel = 0
        // prepare a new board for current level
        createNewBoard()
        
    }
    // Deletes all blocks surrounding tapped block that have the same color
    func deleteGroup(currentBlock : Block){
        if (currentBlock.sameColorNeighbors.count > 0){
            blocks[currentBlock.row][currentBlock.column].toDelete = true
            deleteMyNeighbors(currentBlock: currentBlock)
            if (gameMode == .classic){
                redoBlockArray()
            }
            else {
                redoBlockArraySurv()
            }
        }
    }
    
    //MARK: - auxiliary functions for SURVIVAL MODE
    func createNewBoard(){
        var randomColor : Color = Color.gray
        var gameBlocks : [[Block]] = []
        fallingBlock = nil
        timeLeft = settings.maxTime
        //create array of blocks, starting by adding the empty rows at the top (the block-falling area)
        for i  in 0..<offset {
            var row : [Block] = []
            for j in 0..<tcols {
                row.append(Block(size: blockSize, color: randomColor, row: i, column: j, toDelete: false, deleted: true, sameColorNeighbors: []))
            }
            gameBlocks.append(row)
        }
        //then add the colored blocks to the actual playing area
        for i  in offset..<trows {
            var row : [Block] = []
            for j in 0..<tcols {
                randomColor = getRandomColor()
                row.append(Block(size: blockSize, color: randomColor, row: i, column: j, toDelete: false, deleted: false, sameColorNeighbors: []))
            }
            gameBlocks.append(row)
        }
        levelOver = false
        blocks = gameBlocks
        // find same color neighbors for each block
        populatesameColorNeighborsSurv()
        // start process to create falling blocks
        resumeFallingBlocks()
        // create a timer to keep a count down
        createLevelTimer()
        // adjust params for next level
        speed -= 0.1
        currentLevel += 1
    }
    // MARK: SURVIVAL MODE - functions to manage level's count-down timer
    func createLevelTimer() {
        levelTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimeFires), userInfo: nil, repeats: true)
        timeLabel = String(format: "%02d", timeLeft)
    }
    @objc func onTimeFires(){
        timeLeft -= 1
        timeLabel = String(format: "%02d", timeLeft)
        if timeLeft <= 0 {
            stopCountDown()
            pauseFallingBlocks()
            checkGameOver(reason: 3)
        }
    }
    func stopCountDown(){
        levelTimer?.invalidate()
        levelTimer = nil
    }
    
    // MARK: SURVIVAL MODE - functions to manage falling blocks
    // launches timer to control falling block
    func resumeFallingBlocks(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true, block: runEngine)
    }
    // stop a falling block
    func pauseFallingBlocks(){
        timer?.invalidate()
    }
    // create a new block and start moving it down until it finds its place in board or crashes
    func runEngine(timer: Timer){
        // Create a new falling block if we need to
        guard let currentFallingBlock = fallingBlock else {
            let randomColor = getRandomColor()
            let randomCol = Int.random(in: 0..<tcols)
            fallingBlock = Block(size: blockSize, color: randomColor, row: 0, column: randomCol, toDelete: false, deleted: true, falling: true, sameColorNeighbors: [])
            blocks[0][randomCol] = fallingBlock!
            return
        }
        //try to move block down
        let newFallingBlock = currentFallingBlock.moveBy(step: 1)
        if isValidMove(fallingBlock: newFallingBlock){
            blocks[currentFallingBlock.row][currentFallingBlock.column] = Block(size: blockSize, color: Color.gray, row: currentFallingBlock.row, column: currentFallingBlock.column, toDelete: false, deleted: true, falling: false, sameColorNeighbors: [])
            fallingBlock = newFallingBlock
            blocks[newFallingBlock.row][newFallingBlock.column] = fallingBlock!
            return
        }
        //check if we need to place falling block on board as a playing piece
        placeFallingBlock()
    }
    // make sure falling block is still in-bounds and there is no other block in that spot
    func isValidMove(fallingBlock: Block)-> Bool{
        if fallingBlock.row > (trows - 1) {
            return false
        }
        if (!blocks[fallingBlock.row][fallingBlock.column].deleted  && !blocks[fallingBlock.row][fallingBlock.column].toDelete) {
            return false
        }
        return true
    }
    // add falling block to the playing blocks and recalculate neighbors
    func placeFallingBlock(){
        guard let currentFallingBlock = fallingBlock else {
            return
        }
        if currentFallingBlock.row < offset {
            stopCountDown()
            pauseFallingBlocks()
            fallingBlock = nil
            checkGameOver(reason: 1)
        }
        blocks[currentFallingBlock.row][currentFallingBlock.column] = Block(size: blockSize, color: currentFallingBlock.color, row: currentFallingBlock.row, column: currentFallingBlock.column, toDelete: false, deleted: false, falling: false, sameColorNeighbors: [])
        fallingBlock = nil
        // find same color neighbors for each block
        redoBlockArraySurv()
    }
   
    // MARK: SURVIVAL MODE - functions to END the game
    // determine if a new level needs to be started or the game is over
    func checkGameOver(reason: Int){
        if currentLevel < levels {
            levelOver = true
            switch reason {
            case 1 :
                levelOverlInfo = "Falling block crashed"
            case 2 :
                levelOverlInfo = "No more moves"
            default:
                levelOverlInfo = "Time is up"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if (!self.gameOver && self.gameMode == .survival) {
                    self.createNewBoard()
                }
            }
            
        }
        else {
            dismissSurvivalGame()
        }
    }
    // stop all moving pieces in game
    func dismissSurvivalGame() {
        stopCountDown()
        pauseFallingBlocks()
        fallingBlock = nil
        gameOver = true
        gameMode = .classic;
    }
    // MARK: SURVIVAL MODE - functions to rearrange blocks in game area
    // Deleted blocks are removed from array and valid blocks are moved down-left to keep a compact group of blocks
    func redoBlockArraySurv(){
        var tempCounter = 0
        var tempColumn : [Block] = []
        var tempArray : [[Block]] = []
        
        //init tempArray starting with the top area (falling blocks area)
        for i  in 0..<offset {
            tempArray.append(blocks[i])
        }
        //init rest of tempArray with empty blocks
        for i  in offset..<trows {
            var row : [Block] = []
            for j in 0..<tcols {
                row.append(Block(size: blockSize, color: Color.gray, row: i, column: j, toDelete: false, deleted: true, sameColorNeighbors: []))
            }
            tempArray.append(row)
        }
        //check column by column all blocks in the playing area of the array
        var currCol = -1
        var fallingBlockCol = false
        for c in 0..<tcols {
            tempColumn = []
            fallingBlockCol = false
            for r in offset..<trows {
                if blocks[r][c].falling {
                    tempArray[r][c] = blocks[r][c]
                    fallingBlockCol = true
                }
                else {
                    if !blocks[r][c].deleted {
                        if !blocks[r][c].toDelete {
                            tempColumn.append(blocks[r][c])
                        }
                        else {
                            tempCounter += 1
                        }
                    }
                }
            }
            //if the current columns still has blocks left, copy into tempArray
            if (!tempColumn.isEmpty || fallingBlockCol) {
                currCol = currCol + 1
                //leave empty the top of the column
                let n_empty = trows - tempColumn.count
                //copy blocks stored in tempColumn to complete the new column
                for i in n_empty..<trows{
                    tempArray[i][currCol] = tempColumn[i - n_empty]
                    tempArray[i][currCol].row = i
                    tempArray[i][currCol].column = currCol
                }
            }
        }
        score += tempCounter * 10
        blocks = tempArray
        // find same color neighbors for each block
        populatesameColorNeighborsSurv()
    }
    
    // identifies neighbors of the same color for each of the blocks still in the playing area
    func populatesameColorNeighborsSurv(){
        var keepPlaying = false;
        for i  in offset..<trows {
            for j in 0..<tcols {
                if (!blocks[i][j].deleted){
                    blocks[i][j].sameColorNeighbors = findMySameColorNeighborsSurv(currentBlock: blocks[i][j])
                    if (!blocks[i][j].sameColorNeighbors.isEmpty){
                        keepPlaying = true;
                    }
                }
            }
        }
        // make sure there are still valid moves
        if (!keepPlaying){
            stopCountDown()
            pauseFallingBlocks()
            fallingBlock = nil
            checkGameOver(reason: 2)
        }
    }
    // determines if direct neighbors are of the same color
    func findMySameColorNeighborsSurv(currentBlock:Block) -> [Neighbor]{
        var tempNeighbors :[Neighbor] = []
        var otherBlock : Block
        // Check 4 neighbors: top, bottom, right, left
        if (currentBlock.row > offset){
            if (!blocks[currentBlock.row - 1][currentBlock.column].deleted){
                otherBlock = blocks[currentBlock.row - 1][currentBlock.column]
                if (currentBlock.color == otherBlock.color){
                    tempNeighbors.append(Neighbor(row: (currentBlock.row - 1), column: currentBlock.column))
                }
            }
        }
        if (currentBlock.row < trows - 1){
            if (!blocks[currentBlock.row + 1][currentBlock.column].deleted){
                otherBlock = blocks[currentBlock.row + 1][currentBlock.column]
                if (currentBlock.color == otherBlock.color){
                    tempNeighbors.append(Neighbor(row: (currentBlock.row + 1), column: currentBlock.column))
                }
            }
        }
        if (currentBlock.column > 0){
            if (!blocks[currentBlock.row][currentBlock.column - 1].deleted){
                otherBlock = blocks[currentBlock.row][currentBlock.column - 1]
                if (currentBlock.color == otherBlock.color){
                    tempNeighbors.append(Neighbor(row: currentBlock.row, column: (currentBlock.column - 1)))
                }
            }
        }
        if (currentBlock.column < tcols - 1){
            if (!blocks[currentBlock.row][currentBlock.column + 1].deleted){
                otherBlock = blocks[currentBlock.row][currentBlock.column + 1]
                if (currentBlock.color == otherBlock.color){
                    tempNeighbors.append(Neighbor(row: currentBlock.row, column: (currentBlock.column + 1)))
                }
            }
        }
        return tempNeighbors
    }
    
    //MARK: - auxiliary functions for CLASSIC mode
    // Deleted blocks are removed from array and valid blocks are moved down-left to keep a compact group of blocks
    func redoBlockArray(){
        var tempCounter = 0
        var tempColumn : [Block] = []
        var tempArray : [[Block]] = []
        //init tempArray with empty blocks
        for i  in 0..<settings.num_blocks {
            var row : [Block] = []
            for j in 0..<settings.num_blocks {
                row.append(Block(size: blockSize, color: Color.white, row: i, column: j, toDelete: false, deleted: true, sameColorNeighbors: []))
            }
            tempArray.append(row)
        }
        //check column by column all blocks in array
        var currCol = -1
        for c in 0..<settings.num_blocks {
            tempColumn = []
            for r in 0..<settings.num_blocks {
                if !blocks[r][c].deleted {
                    if !blocks[r][c].toDelete {
                        tempColumn.append(blocks[r][c])
                    }
                    else {
                        tempCounter += 1
                    }
                }
            }
            //if the current columns still has blocks left, copy into tempArray
            if !tempColumn.isEmpty {
                currCol = currCol + 1
                //leave empty the top of the column
                let n_empty = settings.num_blocks - tempColumn.count
                //copy blocks stored in tempColumn to complete the new column
                for i in n_empty..<settings.num_blocks{
                    tempArray[i][currCol] = tempColumn[i - n_empty]
                    tempArray[i][currCol].row = i
                    tempArray[i][currCol].column = currCol
                }
            }
        }
        score += tempCounter * 10
        blocks = tempArray
        // find same color neighbors for each block
        populatesameColorNeighbors()
    }
    
    // identifies neighbors of the same color for each of the blocks still in the playing area
    func populatesameColorNeighbors(){
        var keepPlaying = false;
        for i  in 0..<settings.num_blocks {
            for j in 0..<settings.num_blocks {
                if (!blocks[i][j].deleted){
                    blocks[i][j].sameColorNeighbors = findMySameColorNeighbors(currentBlock: blocks[i][j])
                    if (!blocks[i][j].sameColorNeighbors.isEmpty){
                        keepPlaying = true;
                    }
                }
            }
        }
        // make sure there are still valid moves
        if (!keepPlaying){
            gameOver = true
        }
    }
    
    // determines if direct neighbors are of the same color
    func findMySameColorNeighbors(currentBlock:Block) -> [Neighbor]{
        var tempNeighbors :[Neighbor] = []
        var otherBlock : Block
        // Check 4 neighbors: top, bottom, right, left
        if (currentBlock.row > 0){
            if (!blocks[currentBlock.row - 1][currentBlock.column].deleted){
                otherBlock = blocks[currentBlock.row - 1][currentBlock.column]
                if (currentBlock.color == otherBlock.color){
                    tempNeighbors.append(Neighbor(row: (currentBlock.row - 1), column: currentBlock.column))
                }
            }
        }
        if (currentBlock.row < settings.num_blocks - 1){
            if (!blocks[currentBlock.row + 1][currentBlock.column].deleted){
                otherBlock = blocks[currentBlock.row + 1][currentBlock.column]
                if (currentBlock.color == otherBlock.color){
                    tempNeighbors.append(Neighbor(row: (currentBlock.row + 1), column: currentBlock.column))
                }
            }
        }
        if (currentBlock.column > 0){
            if (!blocks[currentBlock.row][currentBlock.column - 1].deleted){
                otherBlock = blocks[currentBlock.row][currentBlock.column - 1]
                if (currentBlock.color == otherBlock.color){
                    tempNeighbors.append(Neighbor(row: currentBlock.row, column: (currentBlock.column - 1)))
                }
            }
        }
        if (currentBlock.column < settings.num_blocks - 1){
            if (!blocks[currentBlock.row][currentBlock.column + 1].deleted){
                otherBlock = blocks[currentBlock.row][currentBlock.column + 1]
                if (currentBlock.color == otherBlock.color){
                    tempNeighbors.append(Neighbor(row: currentBlock.row, column: (currentBlock.column + 1)))
                }
            }
        }
        return tempNeighbors
    }
    
    //MARK: - supporting functions for classic and survival modes
    // Recursive function to locate all same color blocks that are linked to the original tapped block
    func deleteMyNeighbors(currentBlock : Block){
        for i in 0..<currentBlock.sameColorNeighbors.count {
            let neighbor = currentBlock.sameColorNeighbors[i]
            let tempBlock = blocks[neighbor.row][neighbor.column]
            if (!blocks[tempBlock.row][tempBlock.column].toDelete){
                blocks[tempBlock.row][tempBlock.column].toDelete = true
                deleteMyNeighbors(currentBlock: tempBlock)
            }
        }
    }
    func getRandomColor() -> Color{
        let intColor = (gameMode == .classic ? Int.random(in: settings.colorRange) : Int.random(in: settings.colorRangeSurv))
        switch intColor {
        case 1:
            return Color.red
        case 2:
            return Color.yellow
        case 3:
            return Color.blue
        case 4:
            return Color.green
        case 5:
            return Color.orange
        default:
            return Color.purple
        }
    }
    
    //MARK: - functions to record and retrieve scores
    func saveScore(username : String){
        if(gameMode == .classic){
            highScoreModel.highscores.append(HighScore(score: self.score, name: username, difficulty: self.settings.c_difficulty.rawValue.capitalized, gameMode: "Classic"))
        }
        else{
            highScoreModel.highscores.append(HighScore(score: self.score, name: username, difficulty: self.settings.s_difficulty.rawValue.capitalized, gameMode: "Survival"))
        }
    }
    
    func findTopTenScores(gameMode: String, difficulty: String) -> [Int]{
        var scores = highScoreModel.highscores.filter{$0.gameMode == gameMode && $0.difficulty == difficulty}
        scores.sort{$0.score>$1.score}
        let topTenScores = Array(scores.prefix(10))
        let indices = topTenScores.map{h in
            highScoreModel.highscores.firstIndex(where: {$0.id == h.id})!
        }
        return indices
    }
    
}
