# NativeRealmBrowser
Lightweight browser that let's you inspect which objects currently are in your realm database on your iOS device or simulator

# Usage

**import** NativeRealmBrowser

- In any UIViewController:
```swift
            if let realmBrowser = RealmBrowser.realmBrowser() {
                present(realmBrowser, animated: true, completion: nil)
            }
            else {
                // Realm error
            }
```    
    
Use one of the three methods to browse your Realm database

/**
         Instantiate the browser using default Realm.
    
         - return an instance of realmBrowser
         */
```swift
    public static func realmBrowser() -> UINavigationController?
```
    /**
         Instantiate the browser using a specific version of Realm.
    
         - parameter realm: Realm
         - returns an instance of realmBrowser
         */
```swift
    public static func realmBrowserForRealm(_ realm: RealmSwift.Realm) -> UINavigationController?
```
    /**
         Instantiate the browser using a specific version of Realm at a specific path.
         init(path: String) is deprecated.
    
         realmBroswerForRealmAtPath now uses the convenience initialiser init(fileURL: NSURL)
    
         - parameter url: URL
         - returns an instance of realmBrowser
         */
```swift
    public static func realmBroswerForRealmURL(_ url: URL) -> UINavigationController?
```


# Requirements

Xcode 7
iOS 8.0
Installation

NativeRealmBrowser is available through CocoaPods. To install it, simply add the following line to your Podfile:

pod "NativeRealmBrowser"

# Future features

Implementing search for objects. Layout improvements.

# Documentation

Available method documentation here

# Author

Tran Minh Quang, trmquang@users.noreply.github.com

# License

NativeRealmBrowser is available under the MIT license. See the LICENSE file for more info.
