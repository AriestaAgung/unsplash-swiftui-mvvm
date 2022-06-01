//
//  HomeView.swift
//  unsplash
//
//  Created by BRIMO on 01/06/22.
//

import Foundation
import SwiftUI
import Moya

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]){
                    ForEach(viewModel.imageURL!, id: \.self) {item in
                        ImageWithDownload(urlString: item)
                    }
                }
                .onAppear{
                    viewModel.getHomeList()
                }
            }
            .navigationTitle("Unsplash Images")
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 13 Pro")
    }
}
