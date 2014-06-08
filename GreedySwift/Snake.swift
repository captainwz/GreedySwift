//
//  Snake.swift
//  game2
//
//  Created by wangzhe on 14-6-7.
//  Copyright (c) 2014年 wangzhe. All rights reserved.
//

import Foundation
import SpriteKit

class Snake{
    
    // the constant stats of the device
    // the arr store the min_x, max_x, min_y, max_y, mid_x, mid_y
    let sceneArr:CGFloat[]
    
    // the reference of the gamescene obj
    let gameScene:GameScene
    
    // the array to store the positions of the blocks
    var blockPosArr:(CGFloat[])[]
    
    // the array to store the block objs
    var blockArr:SKShapeNode[]
    
    // the direction of snake
    var direction:Int[] = [0, 1]
    
    // the apple pos
    var apple_pos:CGFloat[] = [0, 0]
    
    
    init(sceneArr:CGFloat[], gameScene:GameScene, initial:Bool = true){
        self.sceneArr = sceneArr
        self.gameScene = gameScene
        self.blockPosArr = []
        self.blockArr = []
        
        if initial {
            self.initialize()
        }
        
    }
    
    // initilize snake with three blocks
    func initialize(){
        self.addOneBlock(sceneArr[4], y: sceneArr[5], is_head: true)
        self.addOneBlock(sceneArr[4], y: sceneArr[5] - 20.0)
        self.addOneBlock(sceneArr[4], y: sceneArr[5] - 40.0)
    }
    
    
    func addOneBlock(x:CGFloat, y:CGFloat, is_head:Bool = false){
        var block = SKShapeNode()
        var path:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil,  -10.0, -10.0)
        CGPathAddLineToPoint(path, nil, 10.0, -10.0)
        CGPathAddLineToPoint(path, nil, 10.0, 10.0)
        CGPathAddLineToPoint(path, nil, -10.0, 10.0)
        CGPathAddLineToPoint(path, nil, -10.0, -10.0)
        block.path = path
        block.fillColor = SKColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 7.0)
        block.strokeColor = SKColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        if is_head {
            block.fillColor = SKColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            block.strokeColor = SKColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            block.name = "snake_head"
        }
        block.position = CGPoint(x:x, y:y)
        
        
        gameScene.addChild(block)
        
        blockPosArr.append([x, y])
        blockArr.append(block)
    }
    
    func crawl() -> Bool{
        var header_nex_pos = [blockPosArr[0][0] + CGFloat(direction[0]*20), blockPosArr[0][1] + CGFloat(direction[1]*20)]
        
        blockPosArr.insert(header_nex_pos, atIndex:0);
        var last_pos = blockPosArr.removeLast()
        
        // check the snake hit something
        var hit:Bool = false
        
        // if hit itself
        for var idx = 1; idx < blockPosArr.count; idx++ {
            if blockPosArr[0][0] == blockPosArr[idx][0] && blockPosArr[0][1] == blockPosArr[idx][1] {
                hit = true
                break
            }else {
                continue
            }
        
        }
        // if hit fence
        if blockPosArr[0][0] - sceneArr[4] > 201 || blockPosArr[0][0] - sceneArr[4] < -201 || blockPosArr[0][1] - sceneArr[5] > 201 || blockPosArr[0][1] - sceneArr[5] < -201 {
            hit = true
        }
        
        if hit {
            return false
        }
        
        // check if snake will eat the apple
        if blockPosArr[0][0] == apple_pos[0] && blockPosArr[0][1] == apple_pos[1] {
            addOneBlock(last_pos[0], y: last_pos[1])
            gameScene.apple.removeFromParent()
            gameScene.drawApple(self.blockPosArr, mid_x: sceneArr[4], mid_y: sceneArr[5], gameScene: gameScene)
            
            // update current score and best score if necessary
            gameScene.current_score++
            gameScene.score1.text = String(gameScene.current_score)
            if gameScene.current_score > gameScene.best_score {
                gameScene.best_score = gameScene.current_score
                gameScene.score0.text = String(gameScene.best_score)
            }
            
        }else {
            
        }
        
        for var idx = 0; idx < blockPosArr.count; idx++ {
            blockArr[idx].position = CGPoint(x: blockPosArr[idx][0], y: blockPosArr[idx][1])
        }
        
        return true
    }
    
    func changeDirection(direct:Int[]) -> Bool {
        if (direct[0]*direction[0] + direct[1]*direction[1]) != 0 {
            return false
        } else {
            direction = direct
            println(direction)
            return true
        }
    }
    
}