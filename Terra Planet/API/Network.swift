//
//  Network.swift
//  Terra Planet
//
//  Created by f0go on 22/03/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

final class Network {
    static let shared = Network()
    
    func get(_ url: String, callback: @escaping (_ response: NetworkResponse) -> Void) {
        print("📡 GET: \(url)")
        Alamofire.request(url, method: .get).responseJSON { response in
            callback(self.parseResponse(response: response))
        }
    }
    
    func post(_ url: String, data: Parameters, callback: @escaping (_ response: NetworkResponse) -> Void) {
        print("📡 POST: \(url)")
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON { response in
            callback(self.parseResponse(response: response))
        }
    }
    
    private func parseResponse(response: DataResponse<Any>) -> NetworkResponse {
        if let resp = response.response {
            if let json = response.result.value {
                return NetworkResponse(data: JSON(json), status: resp.statusCode)
            }
            else {
                return NetworkResponse(data: [], status: resp.statusCode)
            }
        }
        else {
            return NetworkResponse(data: [], status: 500)
        }
    }
}

struct NetworkResponse {
    let data: JSON
    let status: Int
}
