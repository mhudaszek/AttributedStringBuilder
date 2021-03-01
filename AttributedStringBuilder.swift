//
//  AttributedStringBuilder.swift
//  AttributedStringBuilder
//
//  Created by Mirosław Hudaszek on 01/03/2021.
//

import UIKit

enum Attribute {
    case font(UIFont)
    case textColor(UIColor?)

    var key: NSAttributedString.Key {
        return keyAndValue(for: self).0
    }

    var value: Any? {
        return keyAndValue(for: self).1
    }

    private func keyAndValue(for attribute: Attribute) -> (NSAttributedString.Key, Any?) {
        switch attribute {
        case .font(let value):
            return (.font, value)
        case .textColor(let value):
            return (.foregroundColor, value)
        }
    }
}

public class AttributedStringBuilder {
    private(set) var attributedString = NSMutableAttributedString()

    @discardableResult
    func text(_ string: String, attributes: [Attribute]? = []) -> AttributedStringBuilder {
        let attributes = attributesDictionary(withOverrides: attributes ?? [])
        attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return self
    }

    @discardableResult
    func lineSpacing(_ spacing: CGFloat) -> AttributedStringBuilder {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        return self
    }

    @discardableResult
    func lineHeight(_ lineHeight: CGFloat) -> AttributedStringBuilder {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.string.count))
        return self
    }

    @discardableResult
    func bold(_ text: String..., size: CGFloat) -> AttributedStringBuilder {
        text.forEach {
            let string = attributedString.string
            if let range = string.range(of: $0) {
                attributedString.addAttribute(.font,
                                              value: UIFont.boldSystemFont(ofSize: size),
                                              range: NSRange(range, in: string) )
            }
        }
        return self
    }

    @discardableResult
    func image(_ image: UIImage?, withSizeFittingFontUppercase font: UIFont) -> AttributedStringBuilder {
        guard let scaledImage = image?.scaled(to: font.pointSize) else { return self }
        let attachment = NSTextAttachment()
        attachment.bounds = CGRect(x: font.capHeight / 2, y: (font.capHeight - scaledImage.size.height).rounded() / 2, width: scaledImage.size.width, height: scaledImage.size.height)

        attachment.image = scaledImage
        let attachmentString = NSAttributedString(attachment: attachment)
        attributedString.append(attachmentString)
        return self
    }

    private func attributesDictionary(withOverrides overrides: [Attribute]) -> [NSAttributedString.Key: Any] {
        var attributesDict = [NSAttributedString.Key: Any]()
        overrides.forEach {
            let key = $0.key
            let value = $0.value
            attributesDict[key] = value
        }
        return attributesDict
    }
}

extension UIImage {
    func scaled(to width: CGFloat?) -> UIImage? {
        guard let width = width else { return self }
        let ratio = size.width > width ? width / size.width : size.width / width
        let newSize = CGSize(width: width, height: self.size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage
    }
}
