//
//  GalleryView.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 06/10/23.
//
import Kingfisher
import SwiftUI

struct GalleryView: View {
  @StateObject private var viewModel: GalleryViewModel = ViewModelProvider.instance
    .provideGalleryViewModel()
  
  @State var query: String = ""
  
  private let imageUrlPath = "/full/200,/0/default.jpg"
  
  private let columns = [
    GridItem(.flexible(minimum: 40)),
    GridItem(.flexible(minimum: 40)),
    GridItem(.flexible(minimum: 40)),
  ]
  
  var body: some View {
    HStack(alignment: .top) {
      Image(systemName: "magnifyingglass")
        .resizable()
        .frame(width: 24, height: 24)
      TextField("Search", text: $viewModel.queryText)
        .autocapitalization(.none)
        .autocorrectionDisabled()
    }
      .padding(10)
      .overlay(
        RoundedRectangle(cornerRadius: 4.0).stroke(.gray)
      )
      .padding(.horizontal)
      .onChange(of: viewModel.debouncedText, initial: true, { oldValue, newValue in
        if newValue.isEmpty && !oldValue.isEmpty {
          viewModel.initialLoad()
        } else if !newValue.isEmpty {
          viewModel.search(newValue)
        }
      })
      scrollView.onAppear {
        viewModel.initialLoad()
      }
      if viewModel.viewState.isLoading {
        ProgressView()
      }
    }
  
  private var scrollView: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(
          Array(viewModel.viewState.gallery.enumerated()), id: \.element.id
        ) { index, image in
          ZStack {
            KFImage(URL(string: "\(viewModel.viewState.imageUrl)/\(image.imageId ?? "")\(imageUrlPath)")!)
              .resizable()
              .backgroundDecode()
              .cacheMemoryOnly()
              .resizable()
              .placeholder {
                Image("brokenImage")
                  .resizable()
                  .frame(width: 50, height: 50)
              }
              .fade(duration: 0.25)
              .aspectRatio(1, contentMode: .fill)
            
          }.onAppear {
            viewModel.checkIfLoadNext(image.id)
          }
        }
      }.padding(.horizontal, 4)
    }
  }
}

#Preview {
    GalleryView()
}
