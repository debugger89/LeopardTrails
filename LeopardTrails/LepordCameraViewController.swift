//
//  ViewController.swift
//  LeopardTrails
//
//  Created by Chathura Dushmantha on 6/28/19.
//  Copyright © 2019 debugger. All rights reserved.
//

import UIKit
import ALCameraViewController

class LepordCameraViewController: UIViewController {

    
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = true
    var allowResizing: Bool = true
    var allowMoving: Bool = false
    var minimumSize: CGSize = CGSize(width: 60, height: 60)
    
    @IBOutlet weak var imageView: UIImageView!
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let processViewController = storyBoard.instantiateViewController(withIdentifier: "ProcessImageController") as! ProcessImageController
            
            DispatchQueue.main.async {
                self?.present(processViewController, animated: true, completion: nil)
            }
            
            processViewController.capturedimage = image;
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        DispatchQueue.main.async {
            self.present(cameraViewController, animated: true, completion: nil)
       }
      
    }
    
}

