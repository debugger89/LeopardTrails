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
import Presentr;

class ProcessImageController: UIViewController {
    
    var capturedimage:UIImage!;
    
    @IBOutlet weak var capturedImageView: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var progress : Progress!;

    @IBOutlet weak var identifyBtn: UIButton!
    
    
    @IBAction func viewFilterSettings(_ sender: Any) {
        
        let presenter = Presentr(presentationType: .popup)
        presenter.transitionType = .coverVerticalFromTop
        presenter.dismissTransitionType = .coverVerticalFromTop
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let filterController = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        
       // let filterController = FilterViewController()
        customPresentViewController(presenter, viewController: filterController, animated: true, completion: nil)
        
    }
    
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
    
    
    @IBAction func optimizeSearch(_ sender: UIButton) {
        
        showFilterDialog()
    }
    
    @IBAction func identifyLeopard(_ sender: UIButton) {
        
        let currentNP = "WILPATTU"
        
        
        // get All Ids for matching
        let idList = OpenCVWrapper.getListOfIDs(currentNP);
        
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
            
            var description = "Not found in the database"
            var title = "Not Found"
            
            if(matchedName != ""){
                let matchedLeopard = self.resolveMatchedLeopardData(matchedId: matchedName, currentNationaPark: currentNP)
                if(matchedLeopard == nil){
                    description = matchedName
                    title = matchedName
                }else{
                    description = matchedLeopard!.description
                    title = matchedLeopard!.name
                }
            }
            
            self.showResultDialog(title:title, message:description);
        }
        
        
        
    }
    
    func resolveMatchedLeopardData(matchedId : String, currentNationaPark : String) -> LeopardJsonMapper.Leopard?{
        
        let mapper :LeopardJsonMapper = LeopardJsonMapper();
        let rootData = mapper.loadJson(filename: "id_map")
        let leopardList:[LeopardJsonMapper.Leopard] = rootData!.getMapForNationalPark(nationalParkName: currentNationaPark) ?? []
        
        for leopard in leopardList {
            if(matchedId.caseInsensitiveCompare(leopard.id) == .orderedSame){
                return leopard
            }
        }
        return nil
    }
    
    
    
    
    func showResultDialog(animated: Bool = true, title:String, message:String) {
        
        
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
    
    
    func showFilterDialog(animated: Bool = true) {
        
        // Create a custom view controller
        let filterVC = FilterViewController(nibName: nil, bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: filterVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "OK", height: 60) {
          // Set the user defaults here
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    
}
