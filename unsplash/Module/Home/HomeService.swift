//
//  HomeService.swift
//  unsplash
//
//  Created by BRIMO on 01/06/22.
//

import Foundation
import Moya

enum ImageOrientation: String {
    case landscape = "landscape"
    case portrait = "portrait"
    case squarish = "squarish"
}

enum ImageOrderBy: String {
    case latest = "latest"
    case relevant = "relevant"
}

enum HomeService {
    case getImageList(query: String, page: Int?,_ itemPerPage: Int?,_ orientation: ImageOrientation?, _ orderBy: ImageOrderBy?)
}

extension HomeService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constant.Networking.mainURL) else {fatalError("URL cannot be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getImageList(query: _, page: _, _, _, _):
            return "search/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getImageList(query: _, page: _, _, _, _):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getImageList(let query, let page, let pageItem, let orientation, let orderby):
            return .requestParameters(parameters: [
                "query": query,
                "page": page as Any,
                "per_page": pageItem as Any,
                "order_by": orderby as Any,
                "orientation": orientation as Any,
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            Constant.Networking.apiVersionHeader,
            Constant.Networking.authHeader
        ] as! [String: String]?
    }
}

class HomeServiceData {
    private let provider = MoyaProvider<HomeService>()
    
    func getImageList(query: String, page: Int?,_ itemPerPage: Int?,_ orientation: ImageOrientation?, _ orderBy: ImageOrderBy?, completion: @escaping (Result<HomeRandomImageResponse, Error>?) -> ()) {
        provider.request(.getImageList(query: query, page: page, itemPerPage, orientation, orderBy)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let result = try JSONDecoder().decode(HomeRandomImageResponse.self, from: response.data)
                        completion(.success(result))
                    } catch let err {
                        completion(.failure(err))
                    }
                }
            case.failure(let err):
                completion(.failure(err))
            }
            
        }
    }
}
