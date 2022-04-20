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
    
    private(set) var credentials: String?
    
    let defaultManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            API.host: .disableEvaluation,
        ]

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders

        
        
        let m = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return m
    }()
    
    func setCredentials(_ username: String, _ password: String) {
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        credentials = credentialData.base64EncodedString(options: [])
    }
    
    func get(_ url: String, callback: @escaping (_ response: NetworkResponse) -> Void) {
        print("📡 GET: \(url)")
        
        let headers = credentials != nil ? ["Authorization": "Basic \(credentials!)"] : [:]
        defaultManager.request(url, method: .get, headers: headers).responseJSON { response in
            callback(self.parseResponse(response: response))
        }
    }
    
    func post(_ url: String, data: Parameters, callback: @escaping (_ response: NetworkResponse) -> Void) {
        print("📡 POST: \(url)")
        
        let headers = credentials != nil ? ["Authorization": "Basic \(credentials!)"] : [:]
        defaultManager.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
