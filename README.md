# InfiniteScrollGallery
![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)

InfiniteScrollGallery is an iOS app that allows you to browse an infinite gallery of images. Built using Swift and SwiftUI.

## Requirements

- iOS Deployment Target: 17.0
- Xcode 15.0
- Swift 5.9
- Tested on iPhone 15
  
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

## Contributing

If you have any suggestions or bug reports, please feel free to create a pull request on GitHub.

## License

This project is licensed under the MIT License.

