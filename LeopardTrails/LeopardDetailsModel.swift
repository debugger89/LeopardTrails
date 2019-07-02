//
//  LeopardDetailsModel.swift
//  LeopardTrails
//
//  Created by Chathura Dushmantha on 7/2/19.
//  Copyright © 2019 debugger. All rights reserved.
//

import Foundation

class LeopardDetailsModel: Decodable {
    
    let country : String
    let nationalPark : String
    let leopards : [Leopards]
    
    struct Leopards : Decodable {
    
        var id : String
        var name : String
        var description : String
        var idPath : String
        var location : [String]
    }
    
}
