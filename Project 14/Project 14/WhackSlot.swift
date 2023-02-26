//
//  WhackSlot.swift
//  Project 14
//
//  Created by Евгения Зорич on 23.02.2023.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode, SKPhysicsContactDelegate {
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        mug()
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        mug()
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    
    func hit() {
        isHit = true
        bom()
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
    
    func bom() {
        if let bom = SKEmitterNode(fileNamed: "FireParticles") {
            let deploy = SKAction.run{self.addChild(bom)}
            let delay = SKAction.wait(forDuration: 1.5)
            let delete = SKAction.run {self.removeChildren(in: [bom])}
            run(SKAction.sequence([deploy, delay, delete]))
        }
    }
    
    func mug() {
        if let mug = SKEmitterNode(fileNamed: "penguin_appear") {
            let deploy = SKAction.run{self.addChild(mug)}
            let delay = SKAction.wait(forDuration: 0.3)
            let delete = SKAction.run {self.removeChildren(in: [mug])}
            run(SKAction.sequence([deploy, delay, delete]))
        }
    }
}
