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

    var body: some View {
      Text("Hello!!!").onAppear {
        viewModel.initialLoad()
      }
    }
}

#Preview {
    GalleryView()
}
