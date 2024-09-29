//
//  ContentView.swift
//  DogImage
//
//  Created by Adam Makowski on 24/09/2024.
//

import SwiftUI
import AVKit
import WebKit

struct ContentView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        VStack {
            ZStack{
                if vm.isLoading {
                    ProgressView()
                }
                else{
                    if let url = URL(string: vm.dogDataURL){
                        if url.lastPathComponent.hasSuffix(".mp4") {
                            
                            VideoPlayer(player: AVPlayer(url: url))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.black)
                                .cornerRadius(30)
                                .shadow(radius: 10)
                        }
                        else {
                            GifImageView(url: url)
                                .scaledToFit()

                                .cornerRadius(30)
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                
                Button {
                    vm.downloadDogImage()
                } label: {
                    HStack{
                        Image(systemName: "arrow.2.circlepath.circle")
                        Text("Next Video")
                    }
                    .padding()
                    .tint(.primary)
                    .background()
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }

                
                Button {
                    vm.addToFavorites()
                } label: {
                    Image(systemName: "star.fill")
                        .padding()
                        .tint(vm.isFavorite ? .yellow : .primary)
                        .background()
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
            }

        }
        .onAppear{
            vm.downloadDogImage()
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
        
}


struct GifImageView: UIViewRepresentable {
    private let url: URL?
    init(url: URL?) {
        self.url = url
    }
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        guard let url = self.url else { return webview }
        let data = try? Data(contentsOf: url)
        if let data {
            webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        }
        
        return webview
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}

#Preview {
    ContentView()
        .environmentObject(HomeViewModel())
}
