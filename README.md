# NativeRealmBrowser
Lightweight browser that let's you inspect which objects currently are in your realm database on your iOS device or simulator

# Usage

**import** NativeRealmBrowser

```
let realmBrowser = NativeRealmBrowser.realmBrowser()
self.presentViewController(realmBrowser, animated: true) { 

}
```    
    
Use one of the three methods to browse your Realm database

// get the RealmBrowser for default Realm 
realmBrowser()

// get the RealmBrowser for Realm 
realmBrowserForRealm(realm:Realm)

// get the RealmBrowser for Realm at a specific path
realmBroswerForRealmAtPath(path:String)

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
