//
//  ServerAPI.swift
//  Quick
//
//  Created by David Branse on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerAPI: NSObject {
    static let sharedInstance = ServerAPI()
    
    
    func testPutRequestToMarko() {
        
        let params = ["name":"marlena \"the GOAT\" fejzo",
                      "id":UUID().uuidString]
        
        Alamofire.request("http://10.38.44.7:42069/profile", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
        
    }
}
