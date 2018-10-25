//
//  ViewController.swift
//  NMPickerViewDemo
//
//  Created by Natalia Macambira on 02/06/17.
//  Copyright © 2017 Natalia Macambira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NMPickerViewDelegate {
    
    @IBOutlet var selectedPickerViewLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func callPickerViewAction(_ sender: UIButton) {
        /* Instatiate NMPickerViewController with its Delegate */
        let pickerViewController = NMPickerViewController(delegate: self)
        
        /* Set PikerView Titles */
        pickerViewController.pickerViewTitles = ["Apple", "Banana", "Grape", "Kiwi", "Orange", "Pear", "Pineapple"]
        
        /* [Optional] - Config PickerView row height */
        //pickerViewController.pickerViewRowHeight = 44.0
        
        /* [Optional] - Config PickerView to iniciate with a selected title */
        pickerViewController.pickerViewSelectedTitle = selectedPickerViewLabel.text!
        
        /* [Optional] - Config Title */
        //pickerViewController.isHidden = true
        //pickerViewController.titleLabel.text = "Escolha uma fruta e pressione 'Selecionar' ou 'Cancelar'"
        
        /* [Optional] - Config Cancel and Select Button */
        //pickerViewController.cancelButton.setTitle("Cancelar", for: .normal)
        //pickerViewController.selectButton.setTitle("Selecionar", for: .normal)
        
        /* [Optional] - Config blur effect */
        //pickerViewController.blurEffect = true
        //pickerViewController.blurEffectStyle = .dark
    }
    
    func pickerViewCancelButtonAction() {
        print("PickerView cancel button was pressed")
    }
    
    func pickerViewSelectButtonAction(titleSelected: String) {
        self.selectedPickerViewLabel.text = titleSelected
    }
}
