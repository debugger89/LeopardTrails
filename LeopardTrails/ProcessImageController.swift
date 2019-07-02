//
//  ProcessImageController.swift
//  LeopardTrails
//
//  Created by Chathura Dushmantha on 6/28/19.
//  Copyright © 2019 debugger. All rights reserved.
//

import UIKit
import CoreImage
import PopupDialog

class ProcessImageController: UIViewController {
    
    var capturedimage:UIImage!;
    
    @IBOutlet weak var capturedImageView: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var progress : Progress!;

    @IBOutlet weak var identifyBtn: UIButton!
    
    @IBOutlet weak var retakeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        capturedImageView.image = capturedimage;
        
       
        // Start progress from 0
        progress = Progress(totalUnitCount: 0)
        progressBar.progress = 0.0
        progress.completedUnitCount = 0
        progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        identifyBtn.layer.cornerRadius = 0.1 * identifyBtn.frame.width
        
        retakeBtn.layer.borderWidth = 0.8;
        retakeBtn.layer.borderColor = identifyBtn.layer.backgroundColor
        retakeBtn.layer.cornerRadius = 0.1 * retakeBtn.frame.width
    }
    
    
    @IBAction func identifyLeopard(_ sender: UIButton) {
        
        // get All Ids for matching
        let idList = OpenCVWrapper.getListOfIDs();
        
        var matchedName:String!;
        
        progressBar.progress = 0.0
        progress = Progress(totalUnitCount: Int64(idList.count))
        
        DispatchQueue.global().async {
            for id in idList {
                
                matchedName = OpenCVWrapper.matchSpecificLeopard(withID: self.capturedimage, idPath: id as! String);
                if(matchedName != ""){
                    break;
                }
                
                self.progress.completedUnitCount += 1
                
                let progress1 = Float(self.progress.fractionCompleted)
                
                DispatchQueue.main.async { () -> Void in
                    self.progressBar.setProgress(progress1, animated: true)
                }
                
            }
            
            //complete the progress bar
            DispatchQueue.main.async { () -> Void in
                self.progressBar.setProgress(1, animated: true)
                
                
            }
            
            // let matchedName = OpenCVWrapper.matchLeopard( capturedimage);
            if(matchedName == ""){
                matchedName = "Not found in the database"
            }
            
            
            self.showImageDialog(title:"- Match Result -", message:matchedName);
        }
        
        
        
    }
    
    func readJsonLeopardData() -> [LeopardDetailsModel]{
        
        var leopardMap : [LeopardDetailsModel]!
        
        let url = Bundle.main.url(forResource: "id_map", withExtension: "json")!
        do {
            let data = try Data(contentsOf: url)
            leopardMap = try JSONDecoder().decode([LeopardDetailsModel].self, from: data)
        } catch {
            print(error)
        }
        return leopardMap
    }
    
    
    func showImageDialog(animated: Bool = true, title:String, message:String) {
        
        
        let image = capturedimage;
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
        
        
        // Create second button
        let buttonOk = DefaultButton(title: "OK") {
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOk])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
    
}
