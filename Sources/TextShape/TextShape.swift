// The Swift Programming Language
// https://docs.swift.org/swift-book

import EPath
import SwiftUI

#if canImport(UIKit)
import UIKit
public typealias PlatformFont = UIFont
#elseif canImport(AppKit)
import AppKit
public typealias PlatformFont = NSFont
extension NSFont: @retroactive @unchecked Sendable { }
#endif

public struct TextShape: Shape {
    let text: String
    let font: PlatformFont
    let roundedRadius: CGFloat?
    let roundingRule: ERoundingRule
    
    public init(
        _ text: String,
        font: PlatformFont,
        roundedRadius: CGFloat? = nil,
        roundingRule: ERoundingRule = .right
    ) {
        self.text = text
        self.font = font
        self.roundedRadius = roundedRadius
        self.roundingRule = roundingRule
    }
    
    public func path(in rect: CGRect) -> Path {
        let attrString = NSAttributedString(string: text, attributes: [.font: font])
        let line = CTLineCreateWithAttributedString(attrString)
        
        guard let runs = CTLineGetGlyphRuns(line) as? [CTRun] else {
            return Path()
        }

        let path = CGMutablePath()
        
        for run in runs {
            let glyphCount = CTRunGetGlyphCount(run)
            var glyphs = [CGGlyph](repeating: 0, count: glyphCount)
            var positions = [CGPoint](repeating: .zero, count: glyphCount)

            CTRunGetGlyphs(run, CFRange(), &glyphs)
            CTRunGetPositions(run, CFRange(), &positions)

            let dict = CTRunGetAttributes(run) as NSDictionary
            let font = dict[kCTFontAttributeName] as! CTFont

            for id in 0..<glyphCount {
                if let glyphPath = CTFontCreatePathForGlyph(font, glyphs[id], nil) {
                    let transform = CGAffineTransform(translationX: positions[id].x, y: positions[id].y)
                        .scaledBy(x: 1, y: -1)
                    path.addPath(glyphPath, transform: transform)
                }
            }
        }
        
        let normilizedPath = path.normalized(using: .winding)
        let boundingBox = normilizedPath.boundingBox

        var transform = CGAffineTransform(
            translationX: rect.midX - boundingBox.midX,
            y: rect.midY - boundingBox.midY
        )
        
        if let roundedRadius, roundedRadius > 0 {
            return Path(
                EPath(cgPath: normilizedPath.copy(using: &transform)  ?? CGMutablePath())
                    .rounded(radius: roundedRadius, rule: roundingRule)
                    .cgPath
            )
        }

        return Path(normilizedPath.copy(using: &transform)  ?? CGMutablePath())
    }
}
