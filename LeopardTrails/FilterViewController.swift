//
//  FilterViewController.swift
//  LeopardTrails
//
//  Created by Chathura Dushmantha on 7/3/19.
//  Copyright © 2019 debugger. All rights reserved.
//

import UIKit
import Presentr


class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var nationalParksSelector: UIPickerView!
    @IBOutlet weak var sensitivitySlider: UISlider!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nationalParksSelector.delegate = self
        self.nationalParksSelector.dataSource = self
        
        pickerData = ["YALA", "WILPATTU"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        saveBtn.layer.cornerRadius = 0.1 * saveBtn.frame.width
        
        cancelBtn.layer.borderWidth = 0.8;
        cancelBtn.layer.borderColor = saveBtn.layer.backgroundColor
        cancelBtn.layer.cornerRadius = 0.1 * cancelBtn.frame.width
    }

}

extension FilterViewController: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        print("Dismissing View Controller")
        return !keyboardShowing
    }
    
}
