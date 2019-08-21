//
//  FDTakeController.swift
//  CropViewTests
//
//  Created by Chathura Dushmantha on 8/19/19.
//  Copyright © 2019 debugger. All rights reserved.
//

import UIKit
import YPImagePicker

class CameraTakeController: UIViewController {

    var config = YPImagePickerConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setCameraConfig()
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
        
                let cropViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CropViewController") as? CropViewController
                cropViewController?.capturedimage = photo.image
                
                self.getTopMostViewController()?.present(cropViewController!, animated: true, completion: nil)
            }
            
            if cancelled {
                print("Picker was canceled")
            }
            
            
        }
    
        
        DispatchQueue.main.async {
            self.present(picker, animated: true, completion: nil)
        }
        
       
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    func setCameraConfig(){
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = false
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        
       // let coloredImage = UIColor.darkGray.image()
       // UIView.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)
        
        
        //config.bottomMenuItemSelectedColour = UIColor(r: 38, g: 38, b: 38)
        //config.bottomMenuItemUnSelectedColour = UIColor(r: 153, g: 153, b: 153)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

