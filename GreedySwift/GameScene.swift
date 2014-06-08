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
        
        drawFence(mid_x, mid_y: mid_y, gameScene: self)
        
        let up_node = SKSpriteNode(imageNamed: "direction")
        up_node.position = CGPoint(x: mid_x, y: mid_y - 210.0 - 50.0)
        up_node.name = "up_node"
        self.addChild(up_node)
        
        let down_node = SKSpriteNode(imageNamed: "direction")
        down_node.position = CGPoint(x: mid_x, y: mid_y - 210.0 - 50.0 - 50.0 - 10.0)
        down_node.name = "down_node"
        down_node.zRotation = CGFloat(M_PI)
        self.addChild(down_node)
        
        let left_node = SKSpriteNode(imageNamed: "direction")
        left_node.position = CGPoint(x: mid_x - 50.0 - 10.0, y: mid_y - 210.0 - 50.0 - 25.0)
        left_node.name = "left_node"
        left_node.zRotation = CGFloat(M_PI)/2
        self.addChild(left_node)
        
        let right_node = SKSpriteNode(imageNamed: "direction")
        right_node.position = CGPoint(x: mid_x + 50.0 + 10.0, y: mid_y - 210.0 - 50.0 - 25.0)
        right_node.name = "right_node"
        right_node.zRotation = CGFloat(M_PI)/2*3
        self.addChild(right_node)

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            var node:SKNode = nodeAtPoint(location)
            var node_name:String? = node.name
            
            if node_name == "up_node" {
                println("up")
                snake_arr[0].changeDirection([0, 1])
            } else if node_name == "down_node" {
                println("down")
                snake_arr[0].changeDirection([0, -1])
            } else if node_name == "left_node" {
                println("left")
                snake_arr[0].changeDirection([-1, 0])
            } else if node_name == "right_node" {
                println("right")
                snake_arr[0].changeDirection([1, 0])
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if currentTime - timestamp > 0.5 {
            timestamp = currentTime
            snake_arr[0].crawl()
        }
    }
    
    func drawFence(mid_x:CGFloat, mid_y:CGFloat, gameScene:GameScene) {
        var fence = SKShapeNode()
        var path:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil,  -210.0, -210.0)
        CGPathAddLineToPoint(path, nil, 210.0, -210.0)
        CGPathAddLineToPoint(path, nil, 210.0, 210.0)
        CGPathAddLineToPoint(path, nil, -210.0, 210.0)
        CGPathAddLineToPoint(path, nil, -210.0, -210.0)
        fence.path = path
        fence.strokeColor = SKColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        fence.position = CGPoint(x:mid_x, y:mid_y)
        gameScene.addChild(fence)
    }
}
