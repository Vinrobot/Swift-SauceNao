# Swift-SauceNao
SauceNAO API for Swift

## Requirements

- iOS 8.0+, macOS 10.12+
- Swift 4.2

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Swift-SauceNao into your Xcode project using Carthage, specify it in your `Cartfile`:

```cartfile
github "Vinrobot/Swift-SauceNao"
```

Run `carthage update` to build the framework and drag the built `Swift_SauceNao.framework` into your Xcode project or follow [Carthage: Getting started](https://github.com/Carthage/Carthage#getting-started).

## How to use

1) Create an instance of SauceNao
```swift
import Swift_SauceNao

let saucenao = SauceNao(apiKey: "API Key from https://saucenao.com/user.php?page=search-api")
or
let saucenao = SauceNao(apiKey: "API Key", skipLimiters: false) // To skip embedded limiters
```

2) Use one of the search methods.

- Search using an URL:
```swift
let url = URL(string: "https://saucenao.com/images/static/banner.gif")!
saucenao.search(url: url) { (result, error) in
	guard let result = result else {
		print(error ?? "Unknown error")
		return
	}
	
	print("Long: \(result.limits.longRemaining) / \(result.limits.longLimit)")
	print("Short: \(result.limits.shortRemaining) / \(result.limits.shortLimit)")
	
	if let results = result.results {
		for res in results {
			print(res.thumbnail)
		}
	}
}

let urlAsString = "https://saucenao.com/images/static/banner.gif"
saucenao.search(url: urlAsString) { (result, error) in
	...
}
```

- Search using File URL:
```swift
let file = URL(fileURLWithPath: "/Users/Vinrobot/Downloads/banner.gif")
saucenao.search(file: file) { (result, error) in
	...
}
```

- Search using Data:
```swift
let file = URL(fileURLWithPath: "/Users/Vinrobot/Downloads/banner.jpg")

let imageData = try Data(contentsOf: file) // Example by reading file content
let fileName = "image.jpg"
let mimeType = "image/jpeg"

saucenao.search(data: imageData, fileName: fileName, mimeType: mimeType) { (result, error) in
	...
}
```

3) Look at [SauceNaoResult.swift](Swift-SauceNao/SauceNaoResult.swift) to see the content of the `result` variable.
