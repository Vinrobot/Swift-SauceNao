# Swift-SauceNao
SauceNAO API for Swift

## Requirements

- iOS 9.0+, macOS 10.12+
- Swift 5
- Xcode 11+

## Installation

Install using Swift Package Manager.

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

3) Look at [SauceNaoResult.swift](Sources/Swift-SauceNao/SauceNaoResult.swift) to see the content of the `result` variable.
