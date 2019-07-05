//
//  FilterViewController.swift
//  LeopardTrails
//
//  Created by Chathura Dushmantha on 7/3/19.
//  Copyright © 2019 debugger. All rights reserved.
//

import UIKit
import Presentr


class FilterViewController: UIViewController {

    @IBOutlet weak var sensitivitySlider: UISlider!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nationalParkSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let np = UserDefaults.standard.string(forKey: "NATIONAL_PARK") ?? "WILPATTU"
        let sensitivity = UserDefaults.standard.string(forKey: "SENSITIVITY") ?? "0.5"
        
        if(np == "YALA"){
            nationalParkSegment.selectedSegmentIndex = 0
        } else if (np == "WILPATTU"){
             nationalParkSegment.selectedSegmentIndex = 1
        }
        
        
        let sensFloat = Float(sensitivity) ?? 0.5
        sensitivitySlider.setValue(sensFloat, animated: true)
        
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveConfiguration(_ sender: Any) {
        
        let selectedNationalPark = nationalParkSegment.titleForSegment(at: nationalParkSegment.selectedSegmentIndex)
        let sensitivity = sensitivitySlider.value
        
        UserDefaults.standard.set(selectedNationalPark, forKey: "NATIONAL_PARK")
        UserDefaults.standard.set(sensitivity, forKey: "SENSITIVITY")
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        saveBtn.layer.cornerRadius = 0.1 * saveBtn.frame.width
        
        cancelBtn.layer.borderWidth = 0.8;
        cancelBtn.layer.borderColor = saveBtn.layer.backgroundColor
        cancelBtn.layer.cornerRadius = 0.1 * cancelBtn.frame.width
    }

}
