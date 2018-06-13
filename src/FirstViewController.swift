//
//  ViewController.swift
//  TripletCalculator
//
//  Created by Sunny Shin on 2018. 1. 15.
//  Copyright © 2018 Seokyoung Avenue. All rights reserved.
//

import UIKit
import StoreKit


class FirstViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var buttonPrev: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    // for rounded corner
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonBackspace: UIButton!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var buttonFive: UIButton!
    @IBOutlet weak var buttonSix: UIButton!
    @IBOutlet weak var buttonSeven: UIButton!
    @IBOutlet weak var buttonEight: UIButton!
    @IBOutlet weak var buttonNine: UIButton!
    @IBOutlet weak var buttonZero: UIButton!
    @IBOutlet weak var buttonDoubleZero: UIButton!
    @IBOutlet weak var buttonTripleZero: UIButton!
    @IBOutlet weak var buttonDecimalPoint: UIButton!
    @IBOutlet weak var buttonMultiply: UIButton!
    @IBOutlet weak var buttonDivide: UIButton!
    @IBOutlet weak var buttonSubtract: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var buttonEqual: UIButton!
    @IBOutlet weak var buttonDoubleZeros: UIButton!
    
    let calc = Calculation()
    var bigFontSize: CGFloat = 45
    var smallFontSize: CGFloat = 30
    
    var currentPage: Int {
        get {
            return pageControl.currentPage
        }
        set {
            if newValue < 0 {
                pageControl.currentPage = 0
            } else if newValue > PAGE_NUM {
                pageControl.currentPage = PAGE_NUM
            } else {
                pageControl.currentPage = newValue
            }
            calc.c.currentPage = pageControl.currentPage
        }
    }
    
    var _label: Array<String> = Array(repeating: INITIAL_TOTAL_VALUE, count: PAGE_NUM)
    var currentLabel: String {
        get {
            return _label[currentPage]
        }
        set {
            _label[currentPage] = newValue
        }
    }
    
    // MARK: - sys

    func initTotalLabelFontSize() {
        if UIScreen.main.bounds.width > 320.0 {
            bigFontSize = 55
            smallFontSize = 35
        } else {
            bigFontSize = 45
            smallFontSize = 30
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func initButtonCornerRadius() {
        let radius = buttonClear.frame.height / 2.0
        buttonClear.layer.cornerRadius = radius
        buttonBackspace.layer.cornerRadius = radius
        buttonOne.layer.cornerRadius = radius
        buttonTwo.layer.cornerRadius = radius
        buttonThree.layer.cornerRadius = radius
        buttonFour.layer.cornerRadius = radius
        buttonFive.layer.cornerRadius = radius
        buttonSix.layer.cornerRadius = radius
        buttonSeven.layer.cornerRadius = radius
        buttonEight.layer.cornerRadius = radius
        buttonNine.layer.cornerRadius = radius
        buttonZero.layer.cornerRadius = radius
        buttonDoubleZero.layer.cornerRadius = radius
        buttonTripleZero.layer.cornerRadius = radius
        buttonDecimalPoint.layer.cornerRadius = radius
        buttonMultiply.layer.cornerRadius = radius
        buttonDivide.layer.cornerRadius = radius
        buttonSubtract.layer.cornerRadius = radius
        buttonAdd.layer.cornerRadius = radius
        buttonEqual.layer.cornerRadius = radius
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initButtonCornerRadius()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPage = 0
        initTotalLabelFontSize()
        self.processClear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - process buttons
    
    func setTotalLabelFontSizeAndColor(_ count: Int) {
        if count > 11 {
            labelTotal.font = UIFont(name: labelTotal.font.fontName, size: smallFontSize)
        } else {
            labelTotal.font = UIFont(name: labelTotal.font.fontName, size: bigFontSize)
        }

        if currentPage == 0 {
            labelTotal.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else if currentPage == 1 {
            labelTotal.textColor = #colorLiteral(red: 0.5330159068, green: 0.9714623094, blue: 0.503882587, alpha: 1)
        } else {
            labelTotal.textColor = #colorLiteral(red: 0.9939621091, green: 0.4571459889, blue: 0.9865919948, alpha: 1)
        }
    }
    
    func printLabel(stringValue: String, blink: Bool) {
        setTotalLabelFontSizeAndColor(stringValue.count)

        labelTotal.text = stringValue
        if blink {
            UIView.animate(withDuration: 0.1,
                animations: { [weak labelTotal] in labelTotal?.alpha = 0.0 },
                completion: { [weak labelTotal] _ in labelTotal?.alpha = 1.0 })
        }
    }
    
    func getLabel() -> String {
        
        let label = labelTotal.text ?? ""
        return label
    }
    
    func processClear() {
        calc.reset()
        printLabel(stringValue: "0", blink: true)
    }

    func processDecimalPoint() {
        if let result = calc.processDecimalPoint() {
            printLabel(stringValue: result, blink: false)
        }
    }
    
    func processNumber(number: Int) {
        if let result = calc.processNumber(number: number) {
            printLabel(stringValue: result, blink: result.count == 1)
        }
    }
    
    func processArithmeticOperators(_ op: Operator) {
        if let result = calc.processArithmeticOperators(op) {
            printLabel(stringValue: result, blink: true)
        }
        setHistoryColor()
    }
    
    func processEqual() {
        if let result = calc.processEqual() {
            printLabel(stringValue: result, blink: true)
            setHistoryColor()
        }
    }
    
    func setHistoryColor() {
        if calc.processPeekPrev() {
            buttonPrev.setTitleColor(#colorLiteral(red: 0.5330159068, green: 0.9714623094, blue: 0.503882587, alpha: 1), for: .normal)
        } else {
            buttonPrev.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        }
        if calc.processPeekNext() {
            buttonNext.setTitleColor(#colorLiteral(red: 0.5330159068, green: 0.9714623094, blue: 0.503882587, alpha: 1), for: .normal)
        } else {
            buttonNext.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        }
    }
    
    func processPrev() {
        if let value = calc.processPrev() {
            printLabel(stringValue: value, blink: true)
            calc.setCurrentValue(stringValue: value)
            setHistoryColor()
        }
    }
    
    func processNext() {
        if let value = calc.processNext() {
            printLabel(stringValue: value, blink: true)
            calc.setCurrentValue(stringValue: value)
            setHistoryColor()
        }
    }
    
    func processDelete() {
        if let value = calc.processDelete() {
            printLabel(stringValue: value, blink: false)
        }
    }
    
    func processNextPage(_ sender: UISwipeGestureRecognizer) {
        if currentPage < PAGE_NUM {
            currentLabel = getLabel()
            currentPage += 1
            printLabel(stringValue: currentLabel, blink: true)
        }
    }
    
    func processPrevPage(_ sender: UISwipeGestureRecognizer) {
        if currentPage > 0 {
            currentLabel = getLabel()
            currentPage -= 1
            printLabel(stringValue: currentLabel, blink: true)
        }
    }
    
    // MARK: - ib gesture

    @IBAction func swipeLeftGesture(_ sender: UISwipeGestureRecognizer) {
        processNextPage(sender)
    }

    @IBAction func swipeRightGesture(_ sender: UISwipeGestureRecognizer) {
        processPrevPage(sender)
    }
    
    // MARK: - ib history

    @IBAction func buttonPrev(_ sender: UIButton) {
        processPrev()
    }

    @IBAction func buttonNext(_ sender: UIButton) {
        processNext()
    }
    
    // MARK: - ib clear, backspace
    
    @IBAction func buttonDelete(_ sender: UIButton) {
        processDelete()
    }

    @IBAction func buttonClear(_ sender: UIButton) {
        processClear()
    }
    
    // MARK: - ib operators
    
    @IBAction func buttonEqual(_ sender: UIButton) {
        processEqual()
    }
    
    @IBAction func buttonAdd(_ sender: UIButton) {
        processArithmeticOperators(.add)
    }
    
    @IBAction func buttonSubtract(_ sender: UIButton) {
        processArithmeticOperators(.subtract)
    }
    
    @IBAction func buttonMultiply(_ sender: UIButton) {
        processArithmeticOperators(.multiply)
    }
    
    @IBAction func buttonDivide(_ sender: UIButton) {
        processArithmeticOperators(.divide)
    }
    
    // MARK: - ib numbers
    
    @IBAction func buttonDecimalPoint(_ sender: UIButton) {
        processDecimalPoint()
    }
    
    @IBAction func buttonOne(_ sender: UIButton) {
        processNumber(number: 1)
    }
    
    @IBAction func buttonTwo(_ sender: UIButton) {
        processNumber(number: 2)
    }
    
    @IBAction func buttonThree(_ sender: UIButton) {
        processNumber(number: 3)
    }
    
    @IBAction func buttonFour(_ sender: UIButton) {
        processNumber(number: 4)
    }
    
    @IBAction func buttonFive(_ sender: UIButton) {
        processNumber(number: 5)
    }
    
    @IBAction func buttonSix(_ sender: UIButton) {
        processNumber(number: 6)
    }
    
    @IBAction func buttonSeven(_ sender: UIButton) {
        processNumber(number: 7)
    }
    
    @IBAction func buttonEight(_ sender: UIButton) {
        processNumber(number: 8)
    }
    
    @IBAction func buttonNine(_ sender: UIButton) {
        processNumber(number: 9)
    }
    
    @IBAction func buttonZero(_ sender: UIButton) {
        processNumber(number: 0)
    }

    @IBAction func buttonDoubleZero(_ sender: UIButton) {
        processNumber(number: 0)
        processNumber(number: 0)
    }

    @IBAction func buttonTripleZero(_ sender: UIButton) {
        processNumber(number: 0)
        processNumber(number: 0)
        processNumber(number: 0)
    }
}


