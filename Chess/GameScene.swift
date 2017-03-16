//
//  GameScene.swift
//  Chess
//
//  Created by Jonathan on 30/12/16.
//  Copyright © 2016 Jonathan Fiorentini. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var board:Board
    var piecesNode:SKNode = SKNode()
    var firstTouch:UInt64?
    
    override init(size:CGSize) {
        board = Board()
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.addChild(piecesNode)
        self.updateLabels()
    }
    
    func updateLabels (){
        self.piecesNode.removeAllChildren()
        let xOffset:CGFloat = 40
        let yOffset:CGFloat = 40
        for k in 0...63 {
            let skText = SKLabelNode(text: "o")
            skText.name = String(k)
            if let piece = board.pieces.filter({(element) in element.position == UInt64(k)}).first  {
                var text = ""
                switch piece.pieceType {
                case .Bishop:
                    text = "BSP"
                    break
                case .Rook:
                    text = "ROO"
                case .Knight:
                    text = "KNI"
                case .Queen:
                    text = "QN"
                case .Pawn:
                    text = "PN"
                case .King:
                    text = "K"            
                }
                if piece.team == true {
                 text = text + " B"
                }
                skText.text = text
               skText.fontSize = 12
            }
            let position = k
            let xPosition  = CGFloat(7 - position % 8)
            let yPosition  = CGFloat(position / 8)
            skText.position = CGPoint(x:(xOffset*xPosition), y:(yOffset*yPosition))
            piecesNode.addChild(skText)
        }
        piecesNode.position = CGPoint(x: 50, y:self.frame.height/2-200)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let node = self.atPoint(t.location(in: self))
            if let name = node.name {
                if firstTouch == nil {
                    firstTouch = UInt64(name)
                    print(firstTouch)

                }
                else {
                    print(board.didSucessfullyUpdateMove(fromCase: firstTouch!, toCase: UInt64(name)!))
                    Search.searchMoves(board: self.board)
                    firstTouch = nil
                    updateLabels ()
                }
            }
            
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
