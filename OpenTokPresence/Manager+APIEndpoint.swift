//
//  Manager+APIEndpoint.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/16/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import Alamofire

protocol APIEndpoint {

    /// The base URL.
    var baseURLString: String { get }

    /// The encoding to use (e.g. "application/json") for any request parameters.
    var encoding: Alamofire.ParameterEncoding { get }

    /// The HTTP method to use (e.g. "GET").
    var method: Alamofire.Method { get }

    /// The endpoint's path, relative to the base URL.
    var path: String { get }

    var parameters: [String : AnyObject]? { get }

}

extension Manager {
    func request(endpoint: APIEndpoint, parameters: [String : AnyObject]? = nil, headers: [String : String]? = nil) -> Request {
        var allParameters = parameters ?? endpoint.parameters
        if let endpointParameters = endpoint.parameters,
            let _ = parameters
        {
            for (k, v) in endpointParameters {
                allParameters![k] = v
            }
        }
        let urlstring = endpoint.baseURLString + endpoint.path
        return self.request(endpoint.method, urlstring, parameters: allParameters, encoding: endpoint.encoding, headers: headers)
    }
}
