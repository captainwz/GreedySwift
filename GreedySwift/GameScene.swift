//
//  GameScene.swift
//  GreedySwift
//
//  Created by wangzhe on 14-6-7.
//  Copyright (c) 2014年 wangzhe. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var snake_arr:Snake[] =  []
    var timestamp:Double = 0.0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        var min_x = CGRectGetMinX(self.frame)
        var max_x = CGRectGetMaxX(self.frame)
        var min_y = CGRectGetMinY(self.frame)
        var max_y = CGRectGetMaxY(self.frame)
        var mid_x = CGRectGetMidX(self.frame)
        var mid_y = CGRectGetMidY(self.frame)
        var arr = [min_x, max_x, min_y, max_y, mid_x, mid_y]
        
        var snake = Snake(sceneArr:arr, gameScene:self)
        snake_arr.append(snake)

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if currentTime - timestamp > 1 {
            timestamp = currentTime
            snake_arr[0].crawl()
        }
    }
}
