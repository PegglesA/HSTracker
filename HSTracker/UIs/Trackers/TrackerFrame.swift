//
//  TrackerFrame.swift
//  HSTracker
//
//  Created by Benjamin Michotte on 31/03/16.
//  Copyright © 2016 Benjamin Michotte. All rights reserved.
//

import Cocoa

let kFrameWidth = 217.0
let kFrameHeight = 700.0
let kRowHeight = 34.0

let kMediumRowHeight = 29.0
let kMediumFrameWidth = (kFrameWidth / kRowHeight * kMediumRowHeight)

let kSmallRowHeight = 23.0
let kSmallFrameWidth = (kFrameWidth / kRowHeight * kSmallRowHeight)

enum CardSize: Int {
    case Small,
    Medium,
    Big
}

class TrackerFrame: NSView {
    
    var playerType: PlayerType?
    
    init() {
        super.init(frame: NSZeroRect)
        initLayers()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayers()
    }
    
    func initLayers() {
        self.wantsLayer = true
        
        self.layer!.backgroundColor = NSColor.clearColor().CGColor
    }
    
    func ratio(rect: NSRect) -> NSRect {
        return NSMakeRect(rect.origin.x / ratioWidth,
                          rect.origin.y / ratioHeight,
                          rect.size.width / ratioWidth,
                          rect.size.height / ratioHeight)
    }
    
     var textAttributes: [String: AnyObject] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .Right
        
        return [
            NSFontAttributeName: NSFont(name: "Belwe Bd BT", size: 16 / ratioHeight)!,
            NSForegroundColorAttributeName: NSColor.whiteColor(),
            NSStrokeWidthAttributeName: -2,
            NSStrokeColorAttributeName: NSColor.blackColor(),
            NSParagraphStyleAttributeName: paragraph
        ]
    }
    
    var ratioWidth: CGFloat {
        if let playerType = playerType where playerType == .DeckManager {
            return 1.0
        }
        
        var ratio: CGFloat
        switch Settings.instance.cardSize {
        case .Small: ratio = CGFloat(kRowHeight / kSmallRowHeight)
        case .Medium: ratio = CGFloat(kRowHeight / kMediumRowHeight)
        default: ratio = 1.0
        }
        return ratio
    }
    
    var ratioHeight: CGFloat {
        return ratioWidth
    }
    
    func addChild(image: NSImage?, _ rect: NSRect, _ onLayer: CALayer? = nil) -> CALayer? {
        guard let _ = image else { return nil }

        let sublayer = CALayer()
        setImage(sublayer, image)
        sublayer.frame = ratio(rect)
        if let onLayer = onLayer {
            onLayer.addSublayer(sublayer)
        }
        else {
            self.layer?.addSublayer(sublayer)
        }
        return sublayer
    }
    
    func setImage(sublayer: CALayer, _ image: NSImage?) {
        guard let _ = image else { return }
        sublayer.contents = image!
    }
    
    func addText(str: String, _ rect: NSRect, _ onLayer: CALayer? = nil, _ foreground: NSColor? = nil) -> CATextLayer {
        let sublayer = CATextLayer()
        setText(sublayer, str, foreground)
        sublayer.frame = ratio(rect)
        if let onLayer = onLayer {
            onLayer.addSublayer(sublayer)
        }
        else {
            self.layer?.addSublayer(sublayer)
        }
        return sublayer
    }
    
    func setText(sublayer: CATextLayer, _ str: String, _ foreground: NSColor? = nil) {
        var attributes = textAttributes
        if let foreground = foreground {
            attributes[NSForegroundColorAttributeName] = foreground
        }
        sublayer.string = NSAttributedString(string: str, attributes: attributes)
    }
}