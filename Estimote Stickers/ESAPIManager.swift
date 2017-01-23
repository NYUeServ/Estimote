//
//  ESAPI.swift
//  Estimote Stickers
//
//  Created by Jonathan Poch on 1/19/17.
//  Copyright © 2017 Jonathan Poch. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class ESAPIManager {
    static let baseUrl: String = "ec2-107-20-74-207.compute-1.amazonaws.com:3000"
    static func LogStickerData(id: String, name: String, inMotion: Bool, currentState: Int, previousState: Int, acceleration: Double) -> Promise<[NSObject: AnyObject]> {
        return Promise{ fulfill, reject in
            let parameters: [NSObject: AnyObject] = [
                "id": id,
                "name": name,
                "in_motion": inMotion,
                "current_state": currentState,
                "previous_state": previousState,
                "acceleration": acceleration
            ]
            
            Alamofire.request(.POST, baseUrl + "/add", parameters: (parameters as! [String : AnyObject]), encoding: .JSON).responseJSON {
                response in switch response.result {
                case .Success(let json):
                    print("Success: \(json)")
                    let response = json as! [NSObject: AnyObject]
                    fulfill(response)
                    
                case .Failure(let error):
                    print("Request failed. Error: \(error)")
                    reject(error)
                }
            }
        }
    }
}
    
