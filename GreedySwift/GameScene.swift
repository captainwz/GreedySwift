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
    
    //var snake_arr:Snake[] =  []
    var timestamp:Double = 0.0
    var apple = SKShapeNode()
    var gameon:Bool = false
    var attrArr:CGFloat[] = []
    var bestScore:Int = 0
    var score0 = SKLabelNode()
    var currentScore:Int = 0
    var score1 = SKLabelNode()
    var retryLabel = SKLabelNode()
    var didPause = false
    var pauseLabel = SKLabelNode()
    
    var snake:Snake?
    
    override func didMoveToView(view: SKView) {
        
        var minX = CGRectGetMinX(self.frame)
        var maxX = CGRectGetMaxX(self.frame)
        var minY = CGRectGetMinY(self.frame)
        var maxY = CGRectGetMaxY(self.frame)
        var midX = CGRectGetMidX(self.frame)
        var midY = CGRectGetMidY(self.frame)
        attrArr = [minX, maxX, minY, maxY, midX, midY]
        
        // initialize the snake
        snake = Snake(sceneArr:attrArr, gameScene:self)
        
        // initialize the fence
        drawFence(midX, midY: midY, gameScene: self)
        
        
        // initialize the bottons
        let upNode = SKSpriteNode(imageNamed: "direction")
        upNode.position = CGPoint(x: midX, y: midY - 210.0 - 50.0)
        upNode.name = "up_node"
        self.addChild(upNode)
        
        let downNode = SKSpriteNode(imageNamed: "direction")
        downNode.position = CGPoint(x: midX, y: midY - 210.0 - 50.0 - 50.0 - 10.0)
        downNode.name = "down_node"
        downNode.zRotation = CGFloat(M_PI)
        self.addChild(downNode)
        
        let leftNode = SKSpriteNode(imageNamed: "direction")
        leftNode.position = CGPoint(x: midX - 50.0 - 10.0, y: midY - 210.0 - 50.0 - 25.0)
        leftNode.name = "left_node"
        leftNode.zRotation = CGFloat(M_PI)/2
        self.addChild(leftNode)
        
        let rightNode = SKSpriteNode(imageNamed: "direction")
        rightNode.position = CGPoint(x: midX + 50.0 + 10.0, y: midY - 210.0 - 50.0 - 25.0)
        rightNode.name = "right_node"
        rightNode.zRotation = CGFloat(M_PI)/2*3
        self.addChild(rightNode)
        
        // initialize an apple
        drawApple(snake!.blockPosArr, midX: midX, midY: midY, gameScene: self)
        
        gameon = true
        
        // initialize some labels
        let label0 = SKLabelNode(fontNamed:"Gill Sans")
        label0.text = "Best Score:";
        label0.fontSize = 30;
        label0.position = CGPoint(x:attrArr[4] - 150, y:attrArr[5] + 250);
        self.addChild(label0)
        
        score0 = SKLabelNode(fontNamed:"Gill Sans")
        score0.text = String(bestScore);
        score0.fontSize = 30;
        score0.position = CGPoint(x:attrArr[4] - 70, y:attrArr[5] + 250);
        self.addChild(score0)
        
        let label1 = SKLabelNode(fontNamed:"Gill Sans")
        label1.text = "current Score:";
        label1.fontSize = 30;
        label1.position = CGPoint(x:attrArr[4] + 50, y:attrArr[5] + 250);
        self.addChild(label1)
        
        score1 = SKLabelNode(fontNamed:"Gill Sans")
        score1.text = String(currentScore);
        score1.fontSize = 30;
        score1.position = CGPoint(x:attrArr[4] + 150, y:attrArr[5] + 250);
        self.addChild(score1)
        
        retryLabel = SKLabelNode(fontNamed:"Gill Sans")
        retryLabel.text = "Retry";
        retryLabel.name = "retry"
        retryLabel.fontSize = 60;
        retryLabel.position = CGPoint(x:attrArr[4], y:attrArr[5]);
        retryLabel.hidden = true
        self.addChild(retryLabel)
        
        pauseLabel = SKLabelNode(fontNamed:"Gill Sans")
        pauseLabel.text = "pause";
        pauseLabel.name = "pause"
        pauseLabel.fontSize = 30;
        pauseLabel.position = CGPoint(x:attrArr[4] + 200, y:attrArr[5] - 250);
        pauseLabel.hidden = false
        self.addChild(pauseLabel)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            var node:SKNode = nodeAtPoint(location)
            var nodeName:String? = node.name
            
            if nodeName == "retry" && node.hidden == false {
                restartGame()
            }else if nodeName == "up_node" {
                println("up")
                snake?.changeDirection([0, 1])
            } else if nodeName == "down_node" {
                println("down")
                snake?.changeDirection([0, -1])
            } else if nodeName == "left_node" {
                println("left")
                snake?.changeDirection([-1, 0])
            } else if nodeName == "right_node" {
                println("right")
                snake?.changeDirection([1, 0])
            } else if nodeName == "pause" && gameon {
                if !didPause {
                    pauseLabel.text = "go on"
                } else {
                    pauseLabel.text = "pause"
                }
                didPause = !didPause
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if gameon {
            if !didPause {
                if currentTime - timestamp > 0.2 {
                    timestamp = currentTime
                    gameon = snake!.crawl()
                }
            }
            
        }else {
            retryLabel.hidden = false
            pauseLabel.hidden = true
        }
        
    }
    
    func drawFence(midX:CGFloat, midY:CGFloat, gameScene:GameScene) {
        var fence = SKShapeNode()
        var path:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil,  -210.0, -210.0)
        CGPathAddLineToPoint(path, nil, 210.0, -210.0)
        CGPathAddLineToPoint(path, nil, 210.0, 210.0)
        CGPathAddLineToPoint(path, nil, -210.0, 210.0)
        CGPathAddLineToPoint(path, nil, -210.0, -210.0)
        fence.path = path
        fence.strokeColor = SKColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        fence.position = CGPoint(x:midX, y:midY)
        gameScene.addChild(fence)
    }
    
    func drawApple(arr:(CGFloat[])[], midX: CGFloat, midY: CGFloat, gameScene: GameScene) {
        
        var pos:CGPoint = CGPoint(x:0, y:0);
        
        func randRange (lower: Int , upper: Int) -> Int {
            return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
        }
        
        while true {
            var x = midX + CGFloat(randRange(0, 10)*20)
            var y = midY + CGFloat(randRange(0, 10)*20)
            var avail = true
            
            for value in arr {
                if value[0] == x && value[1] == y {
                    avail = false
                }
            }
            
            if avail {
                pos = CGPoint(x: x, y: y)
                snake!.applePos = [x, y]
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
        for obj in snake!.blockArr {
            obj.removeFromParent()
        }
        
        // remove apple
        apple.removeFromParent()
        
        // initialize the snake
        snake = Snake(sceneArr:attrArr, gameScene:self)
        //snake_arr.append(snake)
        
        // initialize an apple
        drawApple(snake!.blockPosArr, midX: attrArr[4], midY: attrArr[5], gameScene: self)
        
        gameon = true
        currentScore = 0
        score1.text = String(0)
        retryLabel.hidden = true
        pauseLabel.hidden = false
        pauseLabel.text = "pause"
        didPause = false
    }


    
}
