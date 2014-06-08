//
//  GameScene.swift
//  GreedySwift
//
//  Created by wangzhe on 14-6-7.
//  Copyright (c) 2014年 wangzhe. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene {
    
    var snake_arr:Snake[] =  []
    var timestamp:Double = 0.0
    var apple = SKShapeNode()
    var gameon:Bool = false
    var attr_arr:CGFloat[] = []
    var best_score:Int = 0
    var score0 = SKLabelNode()
    var current_score:Int = 0
    var score1 = SKLabelNode()
    var retry_label = SKLabelNode()
    var did_pause = false
    var pause_label = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        
        var min_x = CGRectGetMinX(self.frame)
        var max_x = CGRectGetMaxX(self.frame)
        var min_y = CGRectGetMinY(self.frame)
        var max_y = CGRectGetMaxY(self.frame)
        var mid_x = CGRectGetMidX(self.frame)
        var mid_y = CGRectGetMidY(self.frame)
        attr_arr = [min_x, max_x, min_y, max_y, mid_x, mid_y]
        
        // initialize the snake
        var snake = Snake(sceneArr:attr_arr, gameScene:self)
        snake_arr.append(snake)
        
        // initialize the fence
        drawFence(mid_x, mid_y: mid_y, gameScene: self)
        
        
        // initialize the bottons
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
        
        // initialize an apple
        drawApple(snake.blockPosArr, mid_x: mid_x, mid_y: mid_y, gameScene: self)
        
        gameon = true
        
        // initialize some labels
        let label0 = SKLabelNode(fontNamed:"Gill Sans")
        label0.text = "Best Score:";
        label0.fontSize = 30;
        label0.position = CGPoint(x:attr_arr[4] - 150, y:attr_arr[5] + 250);
        self.addChild(label0)
        
        score0 = SKLabelNode(fontNamed:"Gill Sans")
        score0.text = String(best_score);
        score0.fontSize = 30;
        score0.position = CGPoint(x:attr_arr[4] - 70, y:attr_arr[5] + 250);
        self.addChild(score0)
        
        let label1 = SKLabelNode(fontNamed:"Gill Sans")
        label1.text = "current Score:";
        label1.fontSize = 30;
        label1.position = CGPoint(x:attr_arr[4] + 50, y:attr_arr[5] + 250);
        self.addChild(label1)
        
        score1 = SKLabelNode(fontNamed:"Gill Sans")
        score1.text = String(current_score);
        score1.fontSize = 30;
        score1.position = CGPoint(x:attr_arr[4] + 150, y:attr_arr[5] + 250);
        self.addChild(score1)
        
        retry_label = SKLabelNode(fontNamed:"Gill Sans")
        retry_label.text = "Retry";
        retry_label.name = "retry"
        retry_label.fontSize = 60;
        retry_label.position = CGPoint(x:attr_arr[4], y:attr_arr[5]);
        retry_label.hidden = true
        self.addChild(retry_label)
        
        pause_label = SKLabelNode(fontNamed:"Gill Sans")
        pause_label.text = "pause";
        pause_label.name = "pause"
        pause_label.fontSize = 30;
        pause_label.position = CGPoint(x:attr_arr[4] + 200, y:attr_arr[5] - 250);
        pause_label.hidden = false
        self.addChild(pause_label)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            var node:SKNode = nodeAtPoint(location)
            var node_name:String? = node.name
            
            if node_name == "retry" && node.hidden == false {
                restartGame()
            }else if node_name == "up_node" {
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
            } else if node_name == "pause" && gameon {
                if !did_pause {
                    pause_label.text = "go on"
                } else {
                    pause_label.text = "pause"
                }
                did_pause = !did_pause
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if gameon {
            if !did_pause {
                if currentTime - timestamp > 0.2 {
                    timestamp = currentTime
                    gameon = snake_arr[0].crawl()
                }
            }
            
        }else {
            retry_label.hidden = false
            pause_label.hidden = true
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
    
    func drawApple(arr:(CGFloat[])[], mid_x: CGFloat, mid_y: CGFloat, gameScene: GameScene) {
        
        var pos:CGPoint = CGPoint(x:0, y:0);
        
        func randRange (lower: Int , upper: Int) -> Int {
            return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
        }
        
        while true {
            var x = mid_x + CGFloat(randRange(0, 10)*20)
            var y = mid_y + CGFloat(randRange(0, 10)*20)
            var avail = true
            
            for value in arr {
                if value[0] == x && value[1] == y {
                    avail = false
                }
            }
            
            if avail {
                pos = CGPoint(x: x, y: y)
                snake_arr[0].apple_pos = [x, y]
                println(pos)
                break
            } else {
                continue
            }
        }
        
        
        apple = SKShapeNode()
        var path:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil,  -10.0, -10.0)
        CGPathAddLineToPoint(path, nil, 10.0, -10.0)
        CGPathAddLineToPoint(path, nil, 10.0, 10.0)
        CGPathAddLineToPoint(path, nil, -10.0, 10.0)
        CGPathAddLineToPoint(path, nil, -10.0, -10.0)
        apple.path = path
        apple.fillColor = SKColor(red: 150.0/255.0, green: 0.0/255.0, blue: 100.0/255.0, alpha: 7.0)
        apple.strokeColor = SKColor(red: 150/255.0, green: 0.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        apple.position = pos
        gameScene.addChild(apple)
        
    }
    
    func restartGame() {
        // remove the origin things
        for obj in snake_arr[0].blockArr {
            obj.removeFromParent()
        }
        
        snake_arr.removeLast()
        
        // remove apple
        apple.removeFromParent()
        
        // initialize the snake
        var snake = Snake(sceneArr:attr_arr, gameScene:self)
        snake_arr.append(snake)
        
        // initialize an apple
        drawApple(snake.blockPosArr, mid_x: attr_arr[4], mid_y: attr_arr[5], gameScene: self)
        
        gameon = true
        current_score = 0
        score1.text = String(0)
        retry_label.hidden = true
        pause_label.hidden = false
        pause_label.text = "pause"
        did_pause = false
    }


    
}
