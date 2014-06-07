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
    
    
    
    init(sceneArr:CGFloat[], gameScene:GameScene){
        self.sceneArr = sceneArr
        self.gameScene = gameScene
        self.blockPosArr = []
        self.blockArr = []
        
        self.initialize()
        
        println(blockPosArr)
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
        }
        block.position = CGPoint(x:x, y:y)
        
        gameScene.addChild(block)
        
        blockPosArr.append([x, y])
        blockArr.append(block)
    }
    
    func crawl() {
        println("crawl")
//        blockPosArr[0][0] = blockPosArr[0][0]
//        blockPosArr[0][1] = blockPosArr[0][1] + 20.0
//        self.blockArr[0].position = CGPoint(x: blockPosArr[0][0], y: blockPosArr[0][1])
    }
    
    
}