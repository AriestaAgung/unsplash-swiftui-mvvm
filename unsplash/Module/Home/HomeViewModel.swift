//
//  HomeViewModel.swift
//  unsplash
//
//  Created by BRIMO on 01/06/22.
//

import Foundation
import Moya
import Alamofire

extension HomeView {
    
    @MainActor class HomeViewModel: ObservableObject {
        private var service = HomeServiceData()
        
        @Published var imageURL: [String]? = []
        
        private let provider = MoyaProvider<HomeService>()
        
        func getHomeList() {
            getImageLists(query: "Calm", page: nil, nil, nil, nil)
        }
        
        private func getImageLists(query: String, page: Int?,_ itemPerPage: Int?,_ orientation: ImageOrientation?, _ orderBy: ImageOrderBy?) {
            
            let params: Parameters = [
                "query": query,
//                "page": page as Any,
//                "per_page": itemPerPage as Any,
//                "order_by": orderBy ?? "",
//                "orientation": orientation ?? "",
            ]
            let headers: HTTPHeaders = [
                Constant.Networking.version,
                Constant.Networking.authHeader,
                .accept("application/json")
            ]
            let url = "\(Constant.Networking.mainURL)search/photos"
            AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers ).response{ response in
                print("URL : \(url)")
                debugPrint(response)
                do{
                    guard let respData = response.data else {return}
                    let responseBody = try JSONDecoder().decode(HomeRandomImageResponse.self, from: respData)
                    dump(respData.description)
                    switch response.response?.statusCode {
                    case 200:
                        guard let results = responseBody.results else {return}
                        DispatchQueue.main.async {
                            for index in results.indices {
                                guard let urls = results[index].urls else {return}
                                self.imageURL?.append(urls.raw!)
                            }
                        }
                    default:
                        print("Error Code: \(response.response?.statusCode.description) || Message : \(response.error?.localizedDescription)")
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        }
        
        func getImageList(query: String, page: Int?,_ itemPerPage: Int?,_ orientation: ImageOrientation?, _ orderBy: ImageOrderBy?) {
            provider.request(.getImageList(query: query, page: page, itemPerPage, orientation, orderBy)) { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        do {
                            let result = try JSONDecoder().decode(HomeRandomImageResponse.self, from: response.data)
                            guard let resultCollection = result.results else {return}
                            for item in resultCollection {
                                if let url = item.urls?.regular {
                                    dump(url)
                                    DispatchQueue.main.async {
                                        
//                                        self.imageURL?.append(url)
                                    }
                                }
                            }
                            
                        } catch let err {
                            print("error: \(err.localizedDescription)")
                        }
                    }
                case.failure(let err):
                    print("error: \(err.localizedDescription)")
                }
                
            }
        }
        
    }
}
