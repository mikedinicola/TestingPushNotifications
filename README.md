# UITesting: Dealing with Push Notifications

Talk given at [CocoaHeads Nantes](https://www.meetup.com/fr-FR/CocoaHeads-Nantes/) 15/02/2018

[Talk's keynote](https://speakerdeck.com/nicoonguitar/ui-testing-dealing-with-push-notifications)

Based on [Jörn Schoppe](http://www.pixeldock.com/blog/testing-push-notifications-with-xcode-uitests/) 
idea for testing push notifications with UI Tests, 
I took a step forward in order to handle notifications with actions and text inputs. 
In the project the notifications are handled from the Springboard, but by using 
[userNotificationCenter(_:willPresent:withCompletionHandler:)](https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate/1649518-usernotificationcenter)
we could interact with the received notifications while the app is in the foreground.

Also a UI Test example on interacting with the Control Center from the Springboard is added.

## Running the project
Remember to setup the app in Apple Developer website

* Create the project's AppID (or set a new one) on your Apple's developer account 
* Generate APNS certificate for development environment 
* Add certificate to Keychain and extract the .p12 file from it. Don´t forget the password !
* Add the .p12 to UITest project's target.
* Remember to setup NWPusher to push the payload in sandbox environment
