//
//  ImageWithDownload.swift
//  unsplash
//
//  Created by BRIMO on 01/06/22.
//

import Foundation
import SwiftUI

struct ImageWithDownload: View {
    let urlString: String
    @State var data: Data?
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .background(Color.gray)
        } else {
            Image(systemName: "video")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(Color.gray)
                .onAppear{
                    fetchData()
                }
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) {data,_,_ in
            self.data = data
        }
        task.resume()
    }
}


struct ImageWithDownload_Previews: PreviewProvider {
    static var previews: some View {
        ImageWithDownload(urlString: "https://images.unsplash.com/photo-1502230831726-fe5549140034?crop=entropy\\u0026cs=tinysrgb\\u0026fm=jpg\\u0026ixid=MnwxNDI1Njd8MHwxfHNlYXJjaHwxfHxDYWxtfGVufDB8fHx8MTY1NDEwMTI4Mw\\u0026ixlib=rb-1.2.1\\u0026q=80")
    }
}
