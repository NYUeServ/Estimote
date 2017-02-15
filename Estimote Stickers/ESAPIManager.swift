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
    static let baseUrl: String = "http://ec2-54-161-116-6.compute-1.amazonaws.com:3000"
    
    static func GetEvents() -> Promise<[NSObject: AnyObject]> {
        return Promise{ fulfill, reject in

            Alamofire.request(.GET, baseUrl + "/events").responseJSON {
                response in
                print("Response request: \(response.request)")
                switch response.result {
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
    
    static func LogStickerData(id: String, name: String, inMotion: Bool, currentState: Int, previousState: Int, acceleration: Double) -> Promise<String> {
        print("NAME: \(name)")
        return Promise{ fulfill, reject in
            Alamofire.request(.POST, baseUrl + "/add/\(id)/\("Sticker")/\(inMotion)/\(currentState)/\(previousState)/\(acceleration)/", parameters: nil).responseJSON {
                response in switch response.result {
                case .Success(let json):
                    print("Success: \(json)")
                    let response = json as! String
                    fulfill(response)
                    
                case .Failure(let error):
                    print("Request failed. Error: \(error)")
                    reject(error)
                }
            }
        }
    }
}
    
