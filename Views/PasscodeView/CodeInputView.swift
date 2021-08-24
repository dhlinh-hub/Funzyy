//
//  CodeInputView.swift
//  App
//
//  Created by Edric D. on 18/06/2021.
//
import UIKit

open class CodeInputView: UIControl, UITextInput {
    
    public enum ClearButtonMode {
        case never
        case whileEditing
        case always
    }
    
    public enum ClearButtonPosition {
        case trailing(Constraint)
        case leading(Constraint)
        
        public enum Constraint {
            case code
            case superView
        }
    }
    
    public enum Alignment {
        case left
        case center
    }
    
    @IBInspectable
    public var keyboardType: UIKeyboardType = .numberPad
    
    open override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                resignFirstResponder()
            }
        }
    }
    
    public var didFinishedEnterCode:((String)-> Void)?
    
    @IBInspectable
    open var code: String = "" {
        didSet {
            invalidateLayout()
            sendActions(for: .valueChanged)
            if code.count == maxLength, let didFinishedEnterCode = didFinishedEnterCode {
                didFinishedEnterCode(code)
            }
        }
    }
    
    @IBInspectable
    open var errorText: String? = nil {
        didSet {
            bottomTextStack.errorLabel.text = errorText
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    open var errorTextColor: UIColor = .red {
        didSet {
            bottomTextStack.errorLabel.textColor = errorTextColor
        }
    }
    
    @IBInspectable
    open var errorTextFont: UIFont = .systemFont(ofSize: 17) {
        didSet {
            bottomTextStack.errorLabel.font = errorTextFont
            invalidateIntrinsicContentSize()
        }
    }
    
    open var clearOnFocus: Bool = false
    
    @IBInspectable
    open var hintText: String? = nil {
        didSet {
            bottomTextStack.hintLabel.text = hintText
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    open var hintTextColor: UIColor = .gray {
        didSet {
            bottomTextStack.hintLabel.textColor = hintTextColor
        }
    }
    
    @IBInspectable
    open var hintTextFont: UIFont = .systemFont(ofSize: 17) {
        didSet {
            bottomTextStack.hintLabel.font = hintTextFont
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    open var isSecureTextEntry: Bool = true {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    open var maxLength: Int = 6 {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    open var itemSpacing: CGFloat = 4 {
        didSet {
            codeStack.spacing = itemSpacing
        }
    }
    
    @IBInspectable
    open var currorColor: UIColor = UIColor.black {
        didSet {
            cursorView.backgroundColor = currorColor
        }
    }
    
    open var cursorHeight: CGFloat {
        return itemSize.height - 4
    }
    
    @IBInspectable
    open var allowsDoubleTaps: Bool = true
    
    @IBInspectable
    open var itemSize: CGSize = CGSize(width: 46, height: 46) {
        didSet {
            invalidateLayout()
        }
    }
    
    public var clearButtonMode: ClearButtonMode = .whileEditing {
        didSet {
            updateClearButton()
        }
    }
    
    public var clearButtonPosition: ClearButtonPosition = .trailing(.superView) {
        didSet {
            updateClearButton()
        }
    }
    
    public var alignment: Alignment = .left {
        didSet {
            switch alignment {
            case .center:
                bottomTextStack.textAlignment = .center
                containerStack.alignment = .center
            default:
                bottomTextStack.textAlignment = .left
                containerStack.alignment = .leading
            }
            invalidateLayout()
        }
    }
    
    public private(set) var isInserting: Bool = true
    public private(set) var isDeleting: Bool = false
    
    public var autoFocusWhenTappedOnClearButton: Bool = true
    
    //MARK: - UI
    private let codeStack = UIStackView()
    private let clearButton = UIButton()
    private let cursorView = CursorView()
    private let containerStack = UIStackView()
    private let bottomTextStack = BottomTextStackView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTapGesture()
        addDoubleTapsGesture()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        addTapGesture()
        addDoubleTapsGesture()
    }
    
    open func emptyItemView(at index: Int) -> UIView {
        fatalError("Must be overrided")
    }
    
    open func itemView(at index: Int) -> UIView {
        fatalError("Must be overrided")
    }
    
    open func secureItemView(at index: Int) -> UIView {
        fatalError("Must be overrided")
    }
    
    public func invalidateLayout() {
        updateCodeStack(by: code)
        updateCurrorPositionIfNeeds()
        updateClearButton()
    }
    
    // MARK: Adopts UITextInput
    public func text(in range: UITextRange) -> String? {
        return nil
    }
    
    public func replace(_ range: UITextRange, withText text: String) {
        
    }
    
    public var selectedTextRange: UITextRange?
    
    public var markedTextRange: UITextRange?
    
    public var markedTextStyle: [NSAttributedString.Key : Any]?
    
    public func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
        
    }
    
    public func unmarkText() {
        
    }
    
    public var beginningOfDocument: UITextPosition  {
        return UITextPosition()
    }
    
    public var endOfDocument: UITextPosition {
        return UITextPosition()
    }
    
    public func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
        return nil
    }
    
    public func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        return nil
    }
    
    public func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
        return nil
    }
    
    public func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
        return ComparisonResult.orderedSame
    }
    
    public func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
        return 0
    }
    
    public var inputDelegate: UITextInputDelegate?
    
    public var tokenizer: UITextInputTokenizer {
        return UITextInputStringTokenizer(textInput: self)
    }
    
    public func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
        return nil
    }
    
    public func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? {
        return nil
    }
    
    public func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection {
        return NSWritingDirection.leftToRight
    }
    
    public func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) {
        
    }
    
    public func firstRect(for range: UITextRange) -> CGRect {
        return CGRect.zero
    }
    
    public func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    public func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    public func closestPosition(to point: CGPoint) -> UITextPosition? {
        return nil
    }
    
    public func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
        return nil
    }
    
    public func characterRange(at point: CGPoint) -> UITextRange? {
        return nil
    }
}

extension CodeInputView {
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        let ret = super.becomeFirstResponder()
        cursorView.startAnimation()
        updateCurrorPositionIfNeeds()
        updateClearButton()
        if (clearOnFocus) {
            clearState()
        }
        return ret
    }
    
    @discardableResult
    open override func resignFirstResponder() -> Bool {
        let ret = super.resignFirstResponder()
        cursorView.stopAnimation()
        return ret
    }
    
    open override func invalidateIntrinsicContentSize() {
        bottomTextStack.invalidateIntrinsicContentSize()
        containerStack.invalidateIntrinsicContentSize()
        super.invalidateIntrinsicContentSize()
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: containerStack.intrinsicContentSize.height)
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupUI()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func showKeyboard() {
        becomeFirstResponder()
    }
    
    private func addDoubleTapsGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSecure))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleSecure() {
        guard allowsDoubleTaps else { return }
        isSecureTextEntry = !isSecureTextEntry
    }
    
    @objc private func clearAll(sender: UIButton) {
        code = ""
        if autoFocusWhenTappedOnClearButton {
            becomeFirstResponder()
        }
    }
    
    private func clearState() {
        code = ""
        bottomTextStack.clearErrorText()
    }
}


extension CodeInputView: UIKeyInput {
    
    public var hasText: Bool {
        return code.count > 0
    }
    
    public func insertText(_ text: String) {
        if code.count == maxLength || !isEnabled {
            return
        }
        isInserting = true
        isDeleting = false
        code.append(contentsOf: text)
    }
    
    public func deleteBackward() {
        if hasText && isEnabled {
            isDeleting = true
            isInserting = false
            code.removeLast()
        }
    }
    
}

extension CodeInputView {
    
    private func setupUI() {
        cursorView.backgroundColor = .black
        addSubview(cursorView)
        
        clearButton.addTarget(self, action: #selector(clearAll(sender: )), for: .touchUpInside)
        let bundle = Bundle(for: CodeInputView.self)
        let image = UIImage(named: "ClearAll",
                            in: bundle,
                            compatibleWith: nil)
        clearButton.setImage(image, for: .normal)
        addSubview(clearButton)
        
        codeStack.translatesAutoresizingMaskIntoConstraints = false
        codeStack.axis = .horizontal
        codeStack.distribution = .equalSpacing
        codeStack.spacing = itemSpacing
        containerStack.addArrangedSubview(codeStack)
        
        bottomTextStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.addArrangedSubview(bottomTextStack)
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.axis = .vertical
        containerStack.distribution = .equalSpacing
        containerStack.alignment = .leading
        containerStack.spacing = 8
        insertSubview(containerStack, belowSubview: cursorView)
        
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        
        // Trigger value changed
        updateCodeStack(by: code)
        updateCurrorPositionIfNeeds()
        updateClearButton()
    }
    
    private func updateCodeStack(by code: String) {
        var emptyPins:[UIView] = Array(0..<maxLength).map{ emptyItemView(at: $0) }
        
        let codeLength = code.count
        let pins:[UIView] = Array(0..<codeLength).map { isSecureTextEntry ? secureItemView(at: $0) : itemView(at: $0) }
        
        // Creates all enterred items
        for (index, view) in pins.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
            emptyPins[index] = view
        }
        
        // Removes all old items
        codeStack.removeAllArrangedSubviews()
        
        // Layouts all new items
        for view in emptyPins {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
            codeStack.addArrangedSubview(view)
        }
    }
    
    private func updateCurrorPositionIfNeeds() {
        guard isFirstResponder else {
            cursorView.stopAnimation()
            return
        }
        
        let idx = code.count
        var frame: CGRect = .zero
        
        // Needs to call this func to validate arranged subviews of code stack before calculate subviews's frame
        // If not, subviews's bounds/frame is zero :|
        codeStack.layoutIfNeeded()
        if idx == codeStack.arrangedSubviews.count {
            let codeView = codeStack.arrangedSubviews.last!
            frame = convert(codeView.bounds, from: codeView)
            frame.origin.x = frame.maxX
        } else {
            let codeView = codeStack.arrangedSubviews[idx]
            frame = convert(codeView.bounds, from: codeView)
            frame.origin.x = frame.minX
        }
        
        frame.size.width = 1
        frame.size.height = cursorHeight
        cursorView.frame = frame
        cursorView.backgroundColor = currorColor
        cursorView.startAnimation()
    }
    
    private func updateClearButton() {
        switch clearButtonMode {
        case .always:
            clearButton.isHidden = false
        case .never:
            clearButton.isHidden = true
        case .whileEditing:
            clearButton.isHidden = code.isEmpty
        }
        
//        var frame: CGRect = .zero
//        let image = Icon1.icon("clearButton")!
//        let size = CGSize(width: image.size.width, height: codeStack.bounds.height)
//        switch clearButtonPosition {
//        case .trailing(let constraint):
//            switch constraint {
//            case .code:
//                frame = CGRect(x: codeStack.frame.maxX + itemSpacing, y: 0, width: size.width, height: size.height)
//            case .superView:
//                frame = CGRect(x: bounds.width - size.width, y: 0, width: size.width, height: size.height)
//            }
//        case .leading(let constraint):
//            switch constraint {
//            case .code:
//                frame = CGRect(x: bounds.width - size.width, y: 0, width: size.width, height: size.height)
//            case .superView:
//                frame = CGRect(x: bounds.width - size.width, y: 0, width: size.width, height: size.height)
//            }
//        }
//
//        clearButton.frame = frame
//        clearButton.setImage(image, for: .normal)
        bringSubviewToFront(clearButton)
    }
    
}

extension CodeInputView {
    
    class CursorView: UIView {
        private var isBlinking = false
        
        func startAnimation() {
            guard !isBlinking else { return }
            
            isBlinking = true
            
            self.alpha = 1
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut, .repeat, .autoreverse, .allowUserInteraction],
                animations: {
                  self.alpha = 0
                })
        }
        
        func stopAnimation() {
            guard isBlinking else { return }
            
            isBlinking = false
            
            self.alpha = 1
            UIView.animate(
                withDuration: 0.12,
                delay: 0,
                options: [.curveEaseInOut, .beginFromCurrentState],
                animations: {
                    self.alpha = 0
            })
        }
    }
}

fileprivate extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}


fileprivate class BottomTextStackView: UIStackView {
    let errorLabel = UILabel()
    let hintLabel = UILabel()
    
    var textAlignment: NSTextAlignment = .left {
        didSet {
            errorLabel.textAlignment = textAlignment
            hintLabel.textAlignment = textAlignment
        }
    }
    
    func clearErrorText() {
        errorLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        errorLabel.textColor = UIColor.red
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        hintLabel.textColor = UIColor.gray
        hintLabel.numberOfLines = 0
        hintLabel.lineBreakMode = .byWordWrapping
        hintLabel.font = UIFont.systemFont(ofSize: 14)
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(errorLabel)
        addArrangedSubview(hintLabel)
        axis = .vertical
        distribution = .fill
        alignment = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
