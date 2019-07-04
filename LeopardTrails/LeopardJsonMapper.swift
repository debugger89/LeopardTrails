//
//  LeopardDetailsModel.swift
//  LeopardTrails
//
//  Created by Chathura Dushmantha on 7/2/19.
//  Copyright © 2019 debugger. All rights reserved.
//

import Foundation


class LeopardJsonMapper {
    
    class LeopardDetailsRoot: Decodable {
        
        let RootLCountryMap : [LeopardDetailsPark]
        
        func getMapForNationalPark(nationalParkName:String ) -> [Leopard]? {
            
            for park in RootLCountryMap{
                if(park.nationalPark.caseInsensitiveCompare(nationalParkName)  == .orderedSame){
                    return park.leopards;
                }
            }
            
            return nil;
        }
    }
    
    struct LeopardDetailsPark: Decodable {
        
        let country : String
        let nationalPark : String
        let leopards : [Leopard]
        
        
        
    }
    
    struct Leopard : Decodable {
        
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

