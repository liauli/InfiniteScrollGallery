//
//  GalleryView.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 06/10/23.
//

import SwiftUI

struct GalleryView: View {
  @StateObject private var viewModel: GalleryViewModel = ViewModelProvider.instance
    .provideGalleryViewModel()
  
  private let columns = [
    GridItem(.flexible(minimum: 40)),
    GridItem(.flexible(minimum: 40)),
    GridItem(.flexible(minimum: 40)),
  ]
  
  var body: some View {
      scrollView
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
            Color.blue.aspectRatio(1, contentMode: .fill)
            Text(String(image.id))
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
