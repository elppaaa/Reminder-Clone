//
//  BadgeText.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/26.
//

import UIKit

struct BadgeText {
 fileprivate let _color: UIColor
 fileprivate let _text: String
 fileprivate let _font: UIFont

  init(color _color: UIColor, text _text: String, font _font: UIFont = .preferredFont(forTextStyle: .body)) {
    self._color = _color
    self._text = _text
    self._font = _font
  }

  var text: NSAttributedString {
    let str = NSMutableAttributedString(string: "")
    let imageAttach: NSTextAttachment = {
      let attach = NSTextAttachment()
      let size: CGFloat = 8

      let imageConfig = UIImage.SymbolConfiguration(pointSize: size)
      let image = R.Image.circleFill.image
        .withTintColor(_color)
        .withConfiguration(imageConfig)

      attach.image = image
      attach.bounds = CGRect(x: -1, y: (_font.capHeight - size).rounded() / 2, width: size, height: size)
      return attach
    }()

    str.append(NSAttributedString(attachment: imageAttach))
    str.append(NSAttributedString(string: " \(_text)"))

    return str
  }
}
