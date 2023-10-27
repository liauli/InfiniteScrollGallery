# InfiniteScrollGallery
![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)

InfiniteScrollGallery is an iOS app that allows you to browse an infinite gallery of images. Built using Swift and SwiftUI.

## Using SwiftUI and UIKit

This repository provides two branches for different iOS development approaches:

- **main**: The `main` branch is built using SwiftUI, making it suitable for those who want to explore and work with the SwiftUI framework.

- **uikit**: The `uikit` branch is built using UIKit, a traditional iOS framework. If you prefer using UIKit, switch to this branch for UIKit-based development.

Feel free to choose the branch that aligns with your preferred development framework.

## Requirements

- iOS Deployment Target: 15.0
- Xcode 15.0
- Swift 5.9
- Tested on iPhone 15 Simulator (17.0) and iPhone 13 Pro (16.3.1)
  
## Setup

1. Make sure you have Cocoapods installed. You can install it with the following command:
``` bash
sudo gem install cocoapods
```

2. Clone the project to your machine:
``` bash
git clone https://github.com/liauli/InfiniteScrollGallery.git
```
3. Navigate to the project directory:
``` bash
cd InfiniteScrollGallery
```
4. Install Ruby dependencies
``` bash
bundle install
```
6. Install the pods:
``` bash
pod install
```
6. Open the project workspace in Xcode:
``` bash
open InfiniteScrollGallery.xcworkspace
```

## Running the project

Select the InfiniteScrollGallery scheme and the iPhone 15 simulator.

Press Command+R to run the project.

## API

The InfiniteScrollGallery project uses a public API (https://api.artic.edu/docs/) to fetch images. 
The API sometimes returns the same response regardless of the query, which is something that is outside of our control.

### Example when API returns same response

1. Normal API (https://api.artic.edu/api/v1/artworks?fields=id,image_id&limit=15&page=1)
   
![Screenshot 2023-10-08 at 11 45 55](https://github.com/liauli/InfiniteScrollGallery/assets/16285098/14163d56-fccd-4f18-b227-32651aab570c)

2. API with query "cat" (https://api.artic.edu/api/v1/artworks?q=cat&fields=id,image_id&limit=15&page=1)
   
![Screenshot 2023-10-08 at 11 46 08](https://github.com/liauli/InfiniteScrollGallery/assets/16285098/149f4928-3dcd-44c6-ae41-21ee6e112937)

Notice that the ids and image_ids has exactly same value

## Contributing

If you have any suggestions or bug reports, please feel free to create a pull request on GitHub.

## License

This project is licensed under the MIT License.

