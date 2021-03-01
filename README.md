# Attributed String Builder

<img src="https://i.imgur.com/QYZe1lP.png">

# Usage

```swift
let builder = AttributedStringBuilder()
            .text("Lorem ipsum dolor sit amet")
            .bold("ipsum dolor", size: 25)
            .image(UIImage(named: "settingsIcon"),
                   withSizeFittingFontUppercase: UIFont.systemFont(ofSize: 25))
label.attributedText = builder.attributedString
```
