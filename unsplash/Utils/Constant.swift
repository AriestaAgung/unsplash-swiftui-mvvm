//
//  Constant.swift
//  unsplash
//
//  Created by BRIMO on 01/06/22.
//

import Foundation
import Alamofire

struct Constant {
    //MARK: - Networking
    struct Networking {
        static let mainURL                  = "https://api.unsplash.com/"
        static let apiVersionHeader         = "Accept-Version: v1"
        static let version: HTTPHeader      = HTTPHeader(name: "Accept-Version", value: "v1")
        static let authHeader: HTTPHeader   = HTTPHeader(name: "Authorization", value: "Client-ID "+accessCode)
        static let accessCode               = ""
        static let accessSecret             = ""
    }
    
    
}
