//
//  LeopardDetailsModel.swift
//  LeopardTrails
//
//  Created by Chathura Dushmantha on 7/2/19.
//  Copyright © 2019 debugger. All rights reserved.
//

import Foundation


class LeopardJsonMapper {
    
    struct LeopardDetailsRoot: Decodable {
        
        let RootLCountryMap : [LeopardDetailsPark]
        
    }
    
    struct LeopardDetailsPark: Decodable {
        
        let country : String
        let nationalPark : String
        let leopards : [Leopards]
        
        
        
    }
    
    struct Leopards : Decodable {
        
        var id : String
        var name : String
        var description : String
        var idPath : String
        var location : String
        
    }
    
    
    func loadJson(filename fileName: String) -> LeopardDetailsRoot? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(LeopardDetailsRoot.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }


}

