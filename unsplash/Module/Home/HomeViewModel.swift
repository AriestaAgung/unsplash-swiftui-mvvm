//
//  HomeViewModel.swift
//  unsplash
//
//  Created by BRIMO on 01/06/22.
//

import Foundation
import Alamofire

extension HomeView {
    
    @MainActor class HomeViewModel: ObservableObject {
        private var service = HomeServiceData()
        
        @Published var imageURL: [String]? = []
                
        func getHomeList() {
            getImageLists(query: "Calm", page: 4, nil, nil, nil)
        }
        
        private func getImageLists(query: String, page: Int?,_ itemPerPage: Int?,_ orientation: ImageOrientation?, _ orderBy: ImageOrderBy?) {
            var params: Parameters = [
                "query": query
            ]
            if let existedPage = page {
                params["page"] = existedPage
            }
            if let existedItemPerPage = itemPerPage {
                params["per_page"] = existedItemPerPage
            }
            if let existedOrientation = orientation {
                params["orientation"] = existedOrientation
            }
            if let existedOrderBy = orderBy {
                params["order_by"] = existedOrderBy
            }
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
                        print("Error Code: \(String(describing: response.response?.statusCode)) || Message : \(String(describing: response.error?.localizedDescription))")
                    }
                } catch let err {
                    print("Error: \(err.localizedDescription)")
                }
            }
        }
        
    }
}
