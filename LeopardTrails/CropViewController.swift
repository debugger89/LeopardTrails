//
//  ViewController.swift
//  CropViewTests
//
//  Created by Chathura Dushmantha on 8/16/19.
//  Copyright © 2019 debugger. All rights reserved.
//
import UIKit
import Mantis

class CropViewController: UIViewController, CropViewControllerProtocal {
    //let image = UIImage(named: "deepblue")
    
    var capturedimage:UIImage!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = .black
        }
        
        setNeedsStatusBarAppearanceUpdate()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.normalPresent()
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func normalPresent() {
        
        guard let image = capturedimage else {
            return
        }
        
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = self
        
        self.getTopMostViewController()?.present(cropViewController, animated: true)
        
    }
    
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
   
    
    
    
    func didGetCroppedImage(image: UIImage) {
        print("CROPPEDDDDDD!!!")
        
        let processImageController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProcessImageController") as? ProcessImageController
        processImageController?.capturedimage = image
        
        self.getTopMostViewController()?.present(processImageController!, animated: true, completion: nil)
        
        
    }
}

