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
        ImageWithDownload(urlString: "https://hd.unsplash.com/photo-1416339306562-f3d12fefd36f")
    }
}
