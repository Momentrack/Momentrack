//
//  MomentTextView.swift
//  Momentrack
//
//  Created by Nat Kim on 7/24/24.
//

import UIKit

final class MomentTextView: UITextView {
    private enum TextViewConst {
        static let backgroundColor = UIColor.systemGray5.withAlphaComponent(0.5)
        static let cornerRadius = 10.0
        static let containerInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)
        static let placeholderColor = UIColor.systemGray4
        static let placeholderFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let mainTextFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let lineHeight: CGFloat = 24.0
    }
    
    // MARK: - textView
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = TextViewConst.placeholderColor
        textView.isUserInteractionEnabled = false
        textView.isAccessibilityElement = false
        return textView
    }()
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var placeholderText: String? {
        didSet {
            textView.text = placeholderText
            updateTextView()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTextView()
        configureUI()
        addTapGestureToDismissKeyboard()
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        superview?.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
}


private extension MomentTextView {
    func configureUI() {
        delegate = self
        backgroundColor = TextViewConst.backgroundColor
        layer.cornerRadius = TextViewConst.cornerRadius
        clipsToBounds = true
        textContainerInset = TextViewConst.containerInset
        contentInset = .zero
        addSubview(textView)
        
        textView.textContainerInset = TextViewConst.containerInset
        textView.contentInset = contentInset
        textView.font = TextViewConst.placeholderFont
        
        
        let mainTextAttributes: [NSAttributedString.Key: Any] = {
            let mainFont = TextViewConst.mainTextFont
            let style = NSMutableParagraphStyle()
            style.lineSpacing = TextViewConst.lineHeight - mainFont.lineHeight
            
            return [
                .font: mainFont,
                .paragraphStyle: style
            ]
        }()
        self.typingAttributes = mainTextAttributes
        self.attributedText = NSAttributedString(string: self.text, attributes: mainTextAttributes)
        
        self.textContainer.maximumNumberOfLines = 0
        self.textContainer.lineBreakMode = .byWordWrapping
        self.isScrollEnabled = true
    }
    
    func updateTextView() {
        textView.isHidden = !text.isEmpty
        accessibilityValue = text.isEmpty ? placeholderText ?? "" : text
        
        textView.textContainer.exclusionPaths = textContainer.exclusionPaths
        textView.textContainer.lineFragmentPadding = textContainer.lineFragmentPadding
        textView.frame = bounds
    }
}


extension MomentTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextView()
    }
}

extension MomentTextView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UITextView {
            return false
        }
        return true
    }
}
