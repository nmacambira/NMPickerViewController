//
//  NMPickerViewController.swift
//  NMPickerViewDemo
//
//  Created by Natalia Macambira on 02/06/17.
//  Copyright © 2017 Natalia Macambira. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public protocol NMPickerViewDelegate {
    func pickerViewSelectButtonAction(titleSelected: String)
    func pickerViewCancelButtonAction()
}

final public class NMPickerViewController: UIView {
    
    private var delegate: NMPickerViewDelegate?
    private var backgroundView: UIView!
    private var contentView = UIView()
    private var views: [String: Any] = [:]
    private var pickerView: UIPickerView!
    public var blurEffect: Bool = false
    public var blurEffectStyle: UIBlurEffectStyle = UIBlurEffectStyle.light
    public var titleLabel: UILabel = UILabel()
    public var cancelButton: UIButton = UIButton(type: .system)
    public var selectButton: UIButton = UIButton(type: .system)
    public var pickerViewTitles: [String] = []
    public var pickerViewRowHeight: CGFloat = 36.0
    public var pickerViewSelectedTitle: String = ""

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(delegate: NMPickerViewDelegate?) {
        super.init(frame: CGRect.zero)
        
        self.delegate = delegate
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.setupView()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        configVerticalConstraintsOfHiddenViews()
        
        DispatchQueue.main.async {
            self.titleLabel.roundCorners(corners: [.topRight,.topLeft], radius: 4)
            self.titleLabel.layer.masksToBounds = true
           
            self.cancelButton.roundCorners(corners: [.bottomLeft], radius: 4)
            self.cancelButton.layer.masksToBounds = true
            
            self.selectButton.roundCorners(corners: [.bottomRight], radius: 4)
            self.selectButton.layer.masksToBounds = true
        }
        self.layoutIfNeeded()
        
        if blurEffect {
            if !UIAccessibilityIsReduceTransparencyEnabled() {
                blurBackGround(blurEffectStyle)
            }
        }
        
        if !pickerViewTitles.isEmpty {
            if let row = pickerViewTitles.index(of: pickerViewSelectedTitle) {
                pickerView.selectRow(row, inComponent: 0, animated: false)
            }
        }
    }
    
    private func setupView() {
        
        let keyWindow = UIApplication.shared.keyWindow
        let keyWindowBounds: CGRect = (keyWindow?.bounds)!
        self.frame = keyWindowBounds
        keyWindow?.addSubview(self)
        
        backgroundView = UIView(frame: keyWindowBounds)
        
        darkBackground()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backgroundView.addGestureRecognizer(tapRecognizer)
        addSubview(backgroundView)
        
        contentViewConfig()
        addSubview(contentView)
        
        show()
    }
    
    private func blurBackGround(_ blurEffectStyle: UIBlurEffectStyle) {
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.alpha = 1
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.addSubview(blurEffectView)
    }
    
    private func darkBackground() {
        backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        backgroundView.alpha = 0
    }
    
    private func contentViewConfig() {
        
        /* ContentView */
        contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 280)
        contentView.addSubview(titleLabel)
        contentView.addSubview(pickerView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(selectButton)
        
        /* Title */
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: 0.2)
        titleLabel.text = "Please choose a title and press 'Select' or 'Cancel'"
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.gray
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.white
        
        /* NMPickerView */
        pickerView.backgroundColor = UIColor.white
        
        /* Cancel button */
        cancelButton.setTitle("Cancel",for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: 0.3)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        
        /* Selection button */
        selectButton.setTitle("Select",for: .normal)
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        selectButton.backgroundColor = UIColor.white
        selectButton.addTarget(self, action: #selector(selectButtonPressed(_:)), for: .touchUpInside)
        
        /* Constraints */
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        
        views = [
            "titleLabel": titleLabel,
            "pickerView": pickerView,
            "cancelButton": cancelButton,
            "selectButton": selectButton
        ]
        
        var allConstraints = [NSLayoutConstraint]()
        
        let titleLabelHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[titleLabel]-16-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += titleLabelHorizontalConstraint
        
        let datePickerHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[pickerView]-16-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += datePickerHorizontalConstraint
        
        let buttonsHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[cancelButton(==selectButton)]-1-[selectButton]-16-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += buttonsHorizontalConstraint
        
        let selectebuttonVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pickerView]-1-[selectButton(50)]",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += selectebuttonVerticalConstraint
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    private func configVerticalConstraintsOfHiddenViews() {
        
        var verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[titleLabel(50)]-1-[pickerView(160)]-1-[cancelButton(50)]-16-|",
            options: [],
            metrics: nil,
            views: views)
        
        if titleLabel.isHidden {
            
            verticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:[titleLabel(0)]-0-[pickerView(160)]-1-[cancelButton(50)]-16-|",
                options: [],
                metrics: nil,
                views: views)
        }
        
        NSLayoutConstraint.activate(verticalConstraints)
    }
    
    @objc private func cancelButtonPressed(_ sender: UIButton) {
        dismiss()
        delegate?.pickerViewCancelButtonAction()
    }
    
    @objc private func selectButtonPressed(_ sender: UIButton) {
        dismiss()
        var title = pickerViewSelectedTitle
        if !pickerViewTitles.isEmpty && !pickerViewTitles.contains(pickerViewSelectedTitle) {
            title = pickerViewTitles[0]
        }
        delegate?.pickerViewSelectButtonAction(titleSelected: title)
    }
    
    public func show() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
            
            self.contentView.frame = CGRect(x: 0, y: self.frame.height - self.contentView.frame.height, width: self.frame.width, height: self.contentView.frame.height)
            self.backgroundView.alpha = 1.0
            
        }) { (Bool) -> Void in
            
        }
    }
    
    @objc private func dismiss() {
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
            
            self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentView.frame.height)
            self.backgroundView.alpha = 0
            
        }) { (Bool) -> Void in
            self.removeFromSuperview()
        }
    }
}

private extension UIView {
    final func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

extension NMPickerViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewTitles.count
    }
}

extension NMPickerViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerViewRowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String = ""
        if !pickerViewTitles.isEmpty {
            title = pickerViewTitles[row]
        }
        return title
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !pickerViewTitles.isEmpty {
            pickerViewSelectedTitle = pickerViewTitles[row]
        }
    }
}
