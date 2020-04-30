# Launch Screen

If you follow Apple guideline, you must display a view close to the first screen of your app.

A launch screen is not really a splash screen.
It is not the place to display logo or application version, but you can do it.

For more infformation
https://developer.apple.com/ios/human-interface-guidelines/graphics/launch-screen/

## Edit your launch screen

There is many way to do it

### Change the default image for the default LaunchScreen.storyboard

In Xcode project navigator go to 'Resources/Assets.xcassets', select 'LaunchScreenBackground' and drag and drop your own images

### Edit one the storyboard

In Xcode project navigator go to 'LaunchScreen/LaunchScreen.storyboard'
Then edit the view to add standards UIKit custom components

### Edit the default Launch Screen storyboard

In Xcode project navigator go to 'Application Settings/Info.plist'
You can write at line 'Launch screen interface file base name' the wanted launch screen storyboards
For instance for TabBar Application you can set LaunchScreenTabBar
