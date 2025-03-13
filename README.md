# ConcurrentNetworkManager

ConcurrentNetworkManager is a lightweight and efficient Swift package designed for performing network requests using Swift Concurrency and URLSession. It provides a structured and type-safe approach to handling API requests, multipart uploads, and progress tracking.

## Features
- **Concurrency Support**: Utilizes Swift's async/await for modern networking.
- **Multipart Form Data**: Supports file uploads with boundary-separated data.
- **Upload Progress Tracking**: Allows tracking of upload progress using a delegate.
- **Flexible API Client**: A protocol-driven API client implementation.
- **Error Handling**: Defines custom error types for improved debugging.
- **Extensibility**: Designed to be easily extendable for various network needs.

## Installation

### Swift Package Manager (SPM)
To integrate ConcurrentNetworkManager into your project, add it as a dependency in your `Package.swift` file:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/your-repository/ConcurrentNetworkManager.git", from: "1.0.3")
    ]
)
```
Or, if using Xcode:
1. Open Xcode.
2. Navigate to **File > Add Packages**.
3. Enter the repository URL and add the package.

## Usage

### 1. Setting Up API Client
```swift
import ConcurrentNetworkManager

let apiClient = ApiClientImpl(token: "your-api-token")
```

### 2. Defining an API Endpoint
```swift
enum ExampleAPI: EndpointTargetType {
    case fetchUsers
    
    var method: HTTPMethod { .get }
    var path: String { "/users" }
    var baseURL: String { "https://api.example.com" }
    var headers: [String: String] { [:] }
    var urlParameters: [String: any CustomStringConvertible] { [:] }
    var body: Data? { nil }
    var apiVersion: String { "/v1" }
}
```

### 3. Making a Network Request
```swift
Task {
    do {
        let users: [UserModel] = try await apiClient.request(ExampleAPI.fetchUsers)
        print("Fetched users: \(users)")
    } catch {
        print("Failed to fetch users: \(error)")
    }
}
```

### 4. Uploading a File with Progress
```swift
let fileData = Data() // Your file data here
let multipartData = MultipartFormData(
    boundary: UUID().uuidString,
    fileData: fileData,
    fileName: "image.png",
    mimeType: ImageMimeType.png.rawValue,
    parameters: ["user_id": "123"]
)

let uploadProgressDelegate = UploadProgressDelegateImpl { progress in
    print("Upload progress: \(progress * 100)%")
}

Task {
    do {
        let response: Data? = try await apiClient.requestWithProgress(ExampleAPI.uploadFile(multipartData), progressDelegate: uploadProgressDelegate)
        print("Upload successful: \(response != nil)")
    } catch {
        print("Upload failed: \(error)")
    }
}
```

## Project Structure
```
ConcurrentNetworkManager
├── Sources
│   ├── Data
│   │   ├── MultipartFormData.swift
│   ├── Domain
│   │   ├── APIClientError.swift
│   │   ├── HTTPMethod.swift
│   │   ├── ImageMimeType.swift
│   ├── Protocols
│   │   ├── ApiClient.swift
│   │   ├── EndpointTargetType.swift
│   ├── ApiClientImpl.swift
│   ├── UploadProgressDelegate.swift
├── Tests
│   ├── ApiClientTests.swift
│   ├── APIEndpointTests.swift
├── Package.swift
└── README.md
```

## Requirements
- iOS 17.0+
- Swift 6.0+

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author
**Serhan Khan**  
[LinkedIn](https://www.linkedin.com/in/serhan-khan-97b577103/)  
[GitHub](https://github.com/khanboy1989)
