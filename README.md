![](images/Acapulco-yellow.png)

**Acapulco** is a Swift library to register and manage push notifications.

## Features

- [x] Ask for permissions to receive push notifications.
- [x] Register to receive push notifications.
- [x] Text, badges and sounds.
- [x] Silent notifications.
- [x] Send received receipt.
- [x] Send red receipt.
- [x] Support for optional parameters inside the notification payload.
- [x] Open Web page when receiving `url` parameter.
- [x] Debug notification payload.

## Requirements

- iOS 8.0+
- Swift 1.2
- Xcode 6.3

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Sample Project

In order to jump start, you can create the certificates in the [iOS Development Portal](https://developer.apple.com/account/overview.action) and use the provided sample project to test the notification system.
Keep in mind that you need to change the *bundle-id* of the application, generate the corresponding *provisioning profiles* and the *certificates* (distribution and push) as explained in the [Local and Remote Notification Programming Guide](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Introduction.html#//apple_ref/doc/uid/TP40008194-CH1-SW1).

## Installation

### Manually

You can integrate Alamofire into your project manually, just drag and drop the `Acapulco.swift` file in your project.

### CocoaPods

Cocoapods support is coming, stay tuned.

---

## Usage

### Setup remote Push Notification server

In order to maintain the registered device archive and send push notifications you need a remote endpoint. Introducing ThunderBay!

#### ThunderBay

To speed up the process you can use the sample [ThunderBay](https://github.com/DimensionSrl/ThunderBay) push notification server and deploy it to your server.
However we've setup a *demo instance* that will be purged frequently, to let you jump start. You can find it at [acapulco.dimension.it](http://acapulco.dimension.it).


### Register for remote notifications

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Attempt to enable push notifications
    let types : UIUserNotificationType = .Badge | .Sound | .Alert
    let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    return true
}    
```

*Those instructions are intended for iOS 8+.*

### Setup Acapulco

`serverAddress` is your endpoint.
`applicationKey` is the application identifier, in this case provided by *ThunderBay*.

```swift
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    Acapulco.sharedInstance.registerAPNSToken(deviceToken, serverAddress:"acapulco.dimension.it", applicationKey: "8ef1bd2601579e98")
}
```

### Handle foreground notifications

```swift
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {        
        Acapulco.sharedInstance.didReceiveNotification(userInfo)
        let notification = NotificationFactory.PushReceivedNotification(userInfo)
        NSNotificationCenter.defaultCenter().postNotification(notification) // Post the notification
}
```

### Handle background notifications

```swift
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    Acapulco.sharedInstance.didReceiveNotification(userInfo)
    NSUserDefaults.standardUserDefaults().setObject(userInfo, forKey: "backgroundNotification") // Save the last notification for later user
    let notification = NotificationFactory.PushReceivedNotification(userInfo)
    NSNotificationCenter.defaultCenter().postNotification(notification) // Post the notification
    completionHandler(UIBackgroundFetchResult.NewData)
}

```

### Handle application launches to register again and update the values

We save the last notification received.

```swift
func applicationDidBecomeActive(application: UIApplication) {   
    if let backgroundNotification : NSObject = NSUserDefaults.standardUserDefaults().objectForKey("backgroundNotification") as? NSObject {            
        NSUserDefaults.standardUserDefaults().removeObjectForKey("backgroundNotification") // We don't need it anymore
        let notification = NotificationFactory.PushReceivedNotification(backgroundNotification as! [NSObject : AnyObject])
        NSNotificationCenter.defaultCenter().postNotification(notification) // Post the notification
    }
}
```

### Setup callback to get notification type registration result

```swift
func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    application.registerForRemoteNotifications()
}
```

---

## Creators

Acapulco has been developed with love in Trento, Italy by [DIMENSION S.r.l.](http://dimension.it).

### Contributors

- [Nicolò Tosi](http://github.com/nick-mobfarm)
- [Matteo Gavagnin](http://github.com/macteo) ([@macteo](https://twitter.com/macteo))

## License

Acapulco is released under the MIT license.