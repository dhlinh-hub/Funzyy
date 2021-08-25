//
//  FormField.swift
//  App
//
//  Created by Edric D. on 17/06/2021.
//

import UIKit

@objc public protocol FormFieldDelegate: AnyObject {

    @objc optional func formFieldDidTapLeftView(_ formField: FormField)

    @objc optional func formFieldDidTapRightView(_ formField: FormField)

    @objc optional func formFieldTouchesBeganRightView(_ formField: FormField)

    @objc optional func formFieldTouchesEndRightView(_ formField: FormField)

    @objc optional func formFieldShouldBeginEditing(_ formField: FormField) -> Bool // return NO to disallow editing.

    @objc optional func formFieldDidBeginEditing(_ formField: FormField) // became first responder

    @objc optional func formFieldShouldEndEditing(_ formField: FormField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

    @objc optional func formFieldDidEndEditing(_ formField: FormField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

    @objc optional func formFieldDidEndEditing(_ formField: FormField, reason: FormField.DidEndEditingReason) // if implemented, called in place of formFieldDidEndEditing:

    @objc optional func formField(_ formField: FormField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool // return NO to not change text

    @available(iOS 13.0, *)
    @objc optional func formFieldDidChangeSelection(_ formField: FormField)

    @objc optional func formFieldShouldClear(_ formField: FormField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)

    @objc optional func formFieldShouldReturn(_ formField: FormField) -> Bool // called when 'return' key pressed. return NO to ignore.
}

open class FormField: UIView {
    public typealias DidEndEditingReason = UITextField.DidEndEditingReason
    public typealias ViewMode = UITextField.ViewMode

    private lazy var titleLabel = createTitleLabel()
    private lazy var _textField = createTextField()
    var textField: UITextField { _textField }
    private lazy var messageLabel = createMessageLabel()
    private lazy var topTitleLabelConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor)
    private lazy var bottomMessageLabelConstraint = messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
    private lazy var textFieldHeightConstraint = textField.heightAnchor.constraint(equalToConstant: TextField.defaultHeight)

    @IBOutlet public weak var delegate: FormFieldDelegate?

    private lazy var textFieldDelegateImpl = TextFieldDelegate(owner: self)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.subviews.forEach { $0.removeFromSuperview() }
        commonInit()
    }

    @IBInspectable open var maxLength: Int = 999

    @IBInspectable open var textFieldHeight: CGFloat {
        get { textFieldHeightConstraint.constant }
        set { textFieldHeightConstraint.constant = newValue }
    }

    fileprivate var _textFieldBorderColor: UIColor?

    @IBInspectable open var textFieldBorderColor: UIColor? {
        get { _textFieldBorderColor }
        set {
            _textFieldBorderColor = newValue
            textField.layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable open var textFieldBackgroundColor: UIColor? {
        get { textField.backgroundColor }
        set { textField.backgroundColor = newValue }
    }

    @IBInspectable open var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    } // default is nil

    @IBInspectable open var title: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
            let labelText = titleLabel.text
            let isHidden = labelText == nil || labelText!.isEmpty
            guard titleLabel.isHidden != isHidden else { return }
            titleLabel.isHidden = isHidden
            topTitleLabelConstraint.isActive = !isHidden
            invalidateIntrinsicContentSize()
        }
    } // default is nil

    open var attributedTitle: NSAttributedString? {
        get { titleLabel.attributedText }
        set {
            titleLabel.attributedText = newValue
            let labelText = titleLabel.text
            let isHidden = labelText == nil || labelText!.isEmpty
            guard titleLabel.isHidden != isHidden else { return }
            titleLabel.isHidden = isHidden
            topTitleLabelConstraint.isActive = !isHidden
            invalidateIntrinsicContentSize()
        }
    } // default is nil

    @IBInspectable open var message: String? {
        get { messageLabel.text }
        set {
            messageLabel.text = newValue
            let labelText = messageLabel.text
            let isHidden = labelText == nil || labelText!.isEmpty
            guard messageLabel.isHidden != isHidden else { return }
            messageLabel.isHidden = isHidden
            bottomMessageLabelConstraint.isActive = !isHidden
            invalidateIntrinsicContentSize()
        }
    } // default is nil

    open var attributedMessage: NSAttributedString? {
        get { messageLabel.attributedText }
        set {
            messageLabel.attributedText = newValue
            let labelText = messageLabel.text
            let isHidden = labelText == nil || labelText!.isEmpty
            guard messageLabel.isHidden != isHidden else { return }
            messageLabel.isHidden = isHidden
            bottomMessageLabelConstraint.isActive = !isHidden
            invalidateIntrinsicContentSize()
        }
    } // default is nil

    open var attributedText: NSAttributedString? {
        get { textField.attributedPlaceholder }
        set { textField.attributedText = newValue }
    } // default is nil

    open var titleColor: UIColor? {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    } // default is nil. use opaque black

    open var titleFont: UIFont? {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    } // default is nil. use system font 12 pt

    open var inputTextColor: UIColor? {
        get { textField.textColor }
        set { textField.textColor = newValue }
    } // default is nil. use opaque black

    open var inputTextFont: UIFont? {
        get { textField.font }
        set { textField.font = newValue }
    } // default is nil. use system font 12 pt

    open var messageColor: UIColor? {
        get { messageLabel.textColor }
        set { messageLabel.textColor = newValue }
    } // default is nil. use opaque black

    open var messageFont: UIFont? {
        get { messageLabel.font }
        set { messageLabel.font = newValue }
    } // default is nil. use system font 12 pt

    open var inputTextAlignment: NSTextAlignment {
        get { textField.textAlignment }
        set { textField.textAlignment = newValue }
    } // default is NSLeftTextAlignment

    open var defaultTextAttributes: [NSAttributedString.Key: Any] {
        get { textField.defaultTextAttributes }
        set { textField.defaultTextAttributes = newValue }
    } // applies attributes to the full range of text. Unset attributes act like default values.

    @IBInspectable open var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    } // default is nil. string is drawn 70% gray

    open var attributedPlaceholder: NSAttributedString? {
        get { textField.attributedPlaceholder }
        set { textField.attributedPlaceholder = newValue }
    } // default is nil

    open var placeholderColor: UIColor? {
        get { _textField.placeholderColor }
        set { _textField.placeholderColor = newValue }
    }

    @IBInspectable open var clearsOnBeginEditing: Bool {
        get { textField.clearsOnBeginEditing }
        set { textField.clearsOnBeginEditing = newValue }
    } // default is NO which moves cursor to location clicked. if YES, all text cleared

    @IBInspectable open var adjustsFontSizeToFitWidth: Bool {
        get { textField.adjustsFontSizeToFitWidth }
        set { textField.adjustsFontSizeToFitWidth = newValue }
    } // default is NO. if YES, text will shrink to minFontSize along baseline

    open var isEditing: Bool { textField.isEditing }

    @IBInspectable open var allowsEditingTextAttributes: Bool {
        get { textField.allowsEditingTextAttributes }
        set { textField.allowsEditingTextAttributes = newValue }
    } // default is NO. allows editing text attributes with style operations and pasting rich text

    open var typingAttributes: [NSAttributedString.Key: Any]? {
        get { textField.typingAttributes }
        set { textField.typingAttributes = newValue }
    } // automatically resets when the selection changes

    open var clearButtonMode: ViewMode {
        get { textField.clearButtonMode }
        set { textField.clearButtonMode = newValue }
    } // sets when the clear button shows up. default is UITextFieldViewModeNever

    open var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    open override func canPaste(_ itemProviders: [NSItemProvider]) -> Bool {
        textField.canPaste(itemProviders)
    }

    open override func paste(_ sender: Any?) {
        textField.paste(sender)
    }

    open override var pasteConfiguration: UIPasteConfiguration? {
        get { textField.pasteConfiguration }
        set { textField.pasteConfiguration = newValue }
    }

    open override var canBecomeFirstResponder: Bool {
        super.canBecomeFirstResponder && textField.canBecomeFirstResponder
    }

    open override var canResignFirstResponder: Bool {
        super.canResignFirstResponder && textField.canResignFirstResponder
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

    open override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        let width = defaultSize.width
        let height: CGFloat
        if defaultSize.height < 0 {
            let textFieldTopSpacing = titleLabel.isHidden ? 0 : (titleLabel.intrinsicContentSize.height + 4)
            let textFieldBottomSpacing = messageLabel.isHidden ? 0 : (2 + messageLabel.intrinsicContentSize.height)
            height = textFieldTopSpacing + TextField.defaultHeight + textFieldBottomSpacing
        } else {
            height = defaultSize.height
        }
        return CGSize(width: width, height: height)
    }

    open var clearsOnInsertion: Bool {
        get { textField.clearsOnInsertion }
        set { textField.clearsOnInsertion = newValue }
    }

    open override var inputView: UIView? {
        get { super.inputView }
        set { textField.inputView = newValue }
    }

    open override var inputAccessoryView: UIView? {
        get { super.inputAccessoryView }
        set { textField.inputAccessoryView = newValue }
    }

    @IBInspectable open var leftText: String? {
        get { (textField.leftView?.subviews.first(where: { $0 is UILabel }) as? UILabel)?.text }
        set {
            guard let newValue = newValue else {
                textField.leftView = nil
                return textField.leftViewMode = .never
            }
            if let label = textField.leftView?.subviews.first(where: { $0 is UILabel }) as? UILabel {
                label.text = newValue
            } else {
                let view = createSuplementaryView(text: newValue, isLeft: true)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLeft(_:)))
                tapGesture.cancelsTouchesInView = false
                view.addGestureRecognizer(tapGesture)
                textField.leftView = view
                textField.leftViewMode = .always
            }
        }
    } // default is nil

    @IBInspectable open var leftImage: UIImage? {
        get { (textField.leftView?.subviews.first(where: { $0 is UIImageView }) as? UIImageView)?.image }
        set {
            guard let newValue = newValue else {
                textField.leftView = nil
                return textField.leftViewMode = .never
            }
            if let imageView = textField.leftView?.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                imageView.image = newValue
            } else {
                let view = createSuplementaryView(image: newValue)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLeft(_:)))
                tapGesture.cancelsTouchesInView = false
                view.addGestureRecognizer(tapGesture)
                textField.leftView = view
                textField.leftViewMode = .always
            }
        }
    } // default is nil

    open var leftTextColor: UIColor? {
        didSet {
            (textField.leftView?.subviews.first(where: { $0 is UILabel }) as? UILabel)?.textColor = leftTextColor
        }
    } // default is nil

    open var leftTextFont: UIFont? {
        didSet {
            (textField.leftView?.subviews.first(where: { $0 is UILabel }) as? UILabel)?.font = leftTextFont
        }
    } // default is nil

    // Validation TextField

//    open var validationRules: ValidationRuleSet<String>? {
//        didSet {
//            (_textField.validationRules = validationRules)
//        }
//    }
//
//    open var validateOnInputChange: Bool = false {
//        didSet {
//            (_textField.validateOnInputChange(enabled: validateOnInputChange))
//        }
//    }
//
//    open var borderFormFieldValid: Bool = false {
//        didSet {
//            textFieldBorderColor = borderFormFieldValid ? ColorAsset.Color.init(hex: "CBCBCB") : ColorAsset.Color.init(hex: "FF0000")
//        }
//    }

    @IBInspectable open var rightText: String? {
        get { (textField.rightView?.subviews.first(where: { $0 is UILabel }) as? UILabel)?.text }
        set {
            guard let newValue = newValue else {
                textField.rightView = nil
                if textField.clearButtonMode == .never {
                    textField.rightViewMode = .never
                }
                return
            }
            if let label = textField.rightView?.subviews.first(where: { $0 is UILabel }) as? UILabel {
                label.text = newValue
            } else {
                let view = createSuplementaryView(text: newValue, isLeft: false)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRight(_:)))
                tapGesture.cancelsTouchesInView = false
                view.addGestureRecognizer(tapGesture)
                textField.rightView = view
                textField.rightViewMode = .always
            }
        }
    } // default is nil

    @IBInspectable open var rightImage: UIImage? {
        get { (textField.rightView?.subviews.first(where: { $0 is UIImageView }) as? UIImageView)?.image }
        set {
            guard let newValue = newValue else {
                textField.rightView = nil
                if textField.clearButtonMode == .never {
                    textField.rightViewMode = .never
                }
                return
            }
            if let imageView = textField.rightView?.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                imageView.image = newValue
            } else {
                let view = createSuplementaryView(image: newValue)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRight(_:)))
                tapGesture.cancelsTouchesInView = false
                view.addGestureRecognizer(tapGesture)
                textField.rightView = view
                textField.rightViewMode = .always
            }
        }
    } // default is nil

    open var rightTextColor: UIColor? {
        didSet {
            (textField.rightView?.subviews.first(where: { $0 is UILabel }) as? UILabel)?.textColor = rightTextColor
        }
    } // default is nil

    open var rightTextFont: UIFont? {
        didSet {
            (textField.rightView?.subviews.first(where: { $0 is UILabel }) as? UILabel)?.font = rightTextFont
        }
    } // default is nil

    open var rightLabel: UILabel? {
        get { (textField.rightView?.subviews.first(where: { $0 is UILabel }) as? UILabel) }
    } // default is nil
}

extension FormField: UIContentSizeCategoryAdjusting {
    open var adjustsFontForContentSizeCategory: Bool {
        get { textField.adjustsFontForContentSizeCategory }
        set { textField.adjustsFontForContentSizeCategory = newValue }
    }
}

extension FormField: UITextInput {

    open func replace(_ range: UITextRange, withText text: String) {
        textField.replace(range, withText: text)
    }

    open var selectedTextRange: UITextRange? {
        get { textField.selectedTextRange }
        set { textField.selectedTextRange = newValue }
    }

    open var markedTextRange: UITextRange? {
        textField.markedTextRange
    }

    open var markedTextStyle: [NSAttributedString.Key: Any]? {
        get { textField.markedTextStyle }
        set { textField.markedTextStyle = newValue }

    }

    open func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
        textField.setMarkedText(markedText, selectedRange: selectedRange)
    }

    open func unmarkText() {
        textField.unmarkText()
    }

    open var beginningOfDocument: UITextPosition {
        textField.beginningOfDocument
    }

    open var endOfDocument: UITextPosition {
        textField.endOfDocument
    }

    open func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
        textField.textRange(from: fromPosition, to: toPosition)
    }

    open func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        textField.position(from: position, offset: offset)
    }

    open func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
        textField.position(from: position, in: direction, offset: offset)
    }

    open func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
        textField.compare(position, to: other)
    }

    open func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
        textField.offset(from: from, to: toPosition)
    }

    open var inputDelegate: UITextInputDelegate? {
        get { textField.inputDelegate }
        set { textField.inputDelegate = newValue }
    }

    open var tokenizer: UITextInputTokenizer {
        textField.tokenizer
    }

    open func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
        textField.position(within: range, farthestIn: direction)
    }

    open func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? {
        textField.characterRange(byExtending: position, in: direction)
    }

    open func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection {
        textField.baseWritingDirection(for: position, in: direction)
    }

    open func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) {
        textField.setBaseWritingDirection(writingDirection, for: range)
    }

    open func firstRect(for range: UITextRange) -> CGRect {
        textField.firstRect(for: range)
    }

    open func caretRect(for position: UITextPosition) -> CGRect {
        textField.caretRect(for: position)
    }

    open func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        textField.selectionRects(for: range)
    }

    open func closestPosition(to point: CGPoint) -> UITextPosition? {
        textField.closestPosition(to: point)
    }

    open func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
        textField.closestPosition(to: point, within: range)
    }

    open func characterRange(at point: CGPoint) -> UITextRange? {
        textField.characterRange(at: point)
    }

    open func text(in range: UITextRange) -> String? {
        textField.text(in: range)
    }

    open var hasText: Bool {
        textField.hasText
    }

    open func insertText(_ text: String) {
        textField.insertText(text)
    }

    open func deleteBackward() {
        textField.deleteBackward()
    }
}

extension FormField: UITextDraggable, UITextDroppable, UITextPasteConfigurationSupporting {
    open var textDragDelegate: UITextDragDelegate? {
        get { textField.textDragDelegate }
        set { textField.textDragDelegate = newValue }
    }

    open var textDragInteraction: UIDragInteraction? {
        textField.textDragInteraction
    }

    open var isTextDragActive: Bool {
        textField.isTextDragActive
    }

    open var textDragOptions: UITextDragOptions {
        get { textField.textDragOptions }
        set { textField.textDragOptions = newValue }
    }

    open var textDropDelegate: UITextDropDelegate? {
        get { textField.textDropDelegate }
        set { textField.textDropDelegate = newValue }
    }

    open var textDropInteraction: UIDropInteraction? {
        textField.textDropInteraction
    }

    open var isTextDropActive: Bool {
        textField.isTextDropActive
    }

    open var pasteDelegate: UITextPasteDelegate? {
        get { textField.pasteDelegate }
        set { textField.pasteDelegate = newValue }
    }

//    open override func sendActions(for controlEvents: UIControl.Event) {
//        super.sendActions(for: controlEvents)
//        textField.sendActions(for: controlEvents)
//    }
//
//    @available(iOS 14.0, *)
//    open override func sendAction(_ action: UIAction) {
//        super.sendAction(action)
//        textField.sendAction(action)
//    }
//
//    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
//        super.sendAction(action, to: target, for: event)
//        textField.sendAction(action, to: target, for: event)
//    }
}

private extension FormField {
    func commonInit() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(messageLabel)
        titleLabel.isHidden = true
        messageLabel.isHidden = true

        let topTextFieldToSuperviewConstraint = textField.topAnchor.constraint(equalTo: topAnchor)
        topTextFieldToSuperviewConstraint.priority = .defaultHigh

        let bottomTextFieldToSuperviewConstraint = textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomTextFieldToSuperviewConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            topTextFieldToSuperviewConstraint,
            textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFieldHeightConstraint,
            bottomTextFieldToSuperviewConstraint,

            messageLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 2),
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
    }

    func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.init(hex: "505050")
        return label
    }

    func createMessageLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 10)
        label.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        label.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)

        label.textColor = UIColor.init(hex: "FF1A1A")
        return label
    }

    func createTextField() -> TextField {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = textFieldDelegateImpl
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8

        textField.textColor = UIColor.init(hex: "505050")
        textField.layer.borderColor = UIColor.init(hex: "D4D6D7").cgColor
        return textField
    }

    func createSuplementaryView(text: String?, isLeft: Bool) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.text = text
        label.textColor = isLeft ? leftTextColor : rightTextColor
        label.font = isLeft ? leftTextFont : rightTextFont
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false

        let separator = UIView()
        separator.backgroundColor = UIColor(red: 14 / 255.0, green: 22 / 255, blue: 44 / 255, alpha: 0.25)
        separator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(separator)

        var constraints = [
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 130)
        ]

        if isLeft {
            constraints.append(contentsOf: [
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        } else {
            constraints.append(contentsOf: [
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
            ])
        }
        NSLayoutConstraint.activate(constraints)
        return view
    }

    func createSuplementaryView(image: UIImage?) -> CustomUIView {
        let view = CustomUIView()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)

        view.touchBeganCallBack = { [weak self] in
            guard let self = self else { return }
            self.delegate?.formFieldTouchesBeganRightView?(self)
        }

        view.touchEndCallBack = { [weak self] in
            guard let self = self else { return }
            self.delegate?.formFieldTouchesEndRightView?(self)
        }

        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13)
        ])
        return view
    }

    @objc func tapLeft(_ gesture: UIGestureRecognizer) {
        delegate?.formFieldDidTapLeftView?(self)
    }

    @objc func tapRight(_ gesture: UIGestureRecognizer) {
        delegate?.formFieldDidTapRightView?(self)
    }
}

public extension FormField {
    func createNormalFormField() {
        self.titleFont = UIFont.systemFont(ofSize: 18)
        self.messageFont = UIFont.systemFont(ofSize: 18)
        self.inputTextFont = UIFont.systemFont(ofSize: 18)
        self.textField.autocorrectionType = .no
    }
}

private class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    static let defaultHeight: CGFloat = 48

    var placeholderColor: UIColor? {
        get { value(forKeyPath: "placeholderLabel.textColor") as? UIColor }
        set { setValue(newValue, forKeyPath: "placeholderLabel.textColor") }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        textDisplayRect(forBounds: bounds)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        textDisplayRect(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        textDisplayRect(forBounds: bounds)
    }

    func textDisplayRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewWidth = leftViewMode == .never ? 0 : (leftView?.frame.width ?? 0)
        let rightViewWidth = rightViewMode == .never ? 0 : (rightView?.frame.width ?? 0)
        let rightPadding: CGFloat
        switch clearButtonMode {
        case .always:
            let clearButtonFrame = clearButtonRect(forBounds: bounds)
            rightPadding = rightViewWidth + clearButtonFrame.width
        case .whileEditing:
            if isEditing {
                let clearButtonFrame = clearButtonRect(forBounds: bounds)
                rightPadding = rightViewWidth + clearButtonFrame.width
            } else {
                rightPadding = padding.right + rightViewWidth
            }
        case .unlessEditing:
            if isEditing {
                rightPadding = padding.right + rightViewWidth
            } else {
                let clearButtonFrame = clearButtonRect(forBounds: bounds)
                rightPadding = rightViewWidth + clearButtonFrame.width
            }
        case .never:
            rightPadding = padding.right + rightViewWidth
        @unknown default:
            rightPadding = padding.right + rightViewWidth
        }
        let inset = UIEdgeInsets(
            top: padding.top,
            left: padding.left + leftViewWidth,
            bottom: padding.bottom,
            right: rightPadding
        )
        return bounds.inset(by: inset)
    }

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let width: CGFloat = 46
        return .init(x: bounds.width - width - (rightView?.frame.width ?? 0), y: 0, width: width, height: bounds.height)
    }
}

private class TextFieldDelegate: NSObject, UITextFieldDelegate {
    weak var owner: FormField?

    init(owner: FormField?) {
        self.owner = owner
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let owner = owner else { return true }
        return owner.delegate?.formFieldShouldBeginEditing?(owner) ?? true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let owner = owner else { return }
        textField.layer.borderColor = UIColor.init(hex: "4C95E2").cgColor
        owner.delegate?.formFieldDidBeginEditing?(owner)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let owner = owner else { return true }
        return owner.delegate?.formFieldShouldEndEditing?(owner) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let owner = owner else { return }
        textField.layer.borderColor = (owner._textFieldBorderColor ?? UIColor.gray).cgColor
        owner.delegate?.formFieldDidEndEditing?(owner)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let owner = owner else { return }
//        if (!owner.validateOnInputChange || (owner.validateOnInputChange && textField.text?.isEmpty ?? true)) {
//            textField.layer.borderColor = (owner._textFieldBorderColor ?? UIColor.gray).cgColor
//        }
        textField.layer.borderColor = UIColor.init(hex: "D4D6D7").cgColor
        owner.delegate?.formFieldDidEndEditing?(owner, reason: reason) ?? owner.delegate?.formFieldDidEndEditing?(owner)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let owner = owner else { return true }
        guard let text = textField.text?.removingWhitespaces() else {
            return owner.delegate?.formField?(owner, shouldChangeCharactersIn: range, replacementString: string) ?? true
        }
        guard text.count + string.count <= owner.maxLength else {
            return false
        }
        return owner.delegate?.formField?(owner, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    @available(iOS 13.0, *)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let owner = owner else { return }
        owner.delegate?.formFieldDidChangeSelection?(owner)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard let owner = owner else { return true }
        return owner.delegate?.formFieldShouldClear?(owner) ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let owner = owner else { return true }
        return owner.delegate?.formFieldShouldReturn?(owner) ?? true
    }
}

class CustomUIView: UIView {

    var touchBeganCallBack: (() -> Void)? = nil
    var touchEndCallBack: (() -> Void)? = nil

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchBeganCallBack?()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEndCallBack?()
    }
}
