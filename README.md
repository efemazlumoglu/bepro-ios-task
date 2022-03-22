# bepro-ios-task


General

* I did not use storyboard so i add window and rootviewcontroller into app delegate default function didFinishLaunchingWithOption also i need to setup the info.plist file.
* I code my logics in reactive way and i use RxSwift, RxCocoa 
* I implement my view model indepented from ui not testable.
only in view controller load view method inside cannot be readable at first see however i add lots of comments to clear understand.

UI Specs

* I implement loading indicator for request sending and player state.
custom controls are added into the view play, pause, full screen button and also the slider for adjust play time. Current time and the total duration is a plus.
* For playlist section i use table view. Use default cell and inside of it only title of the video is appearing. In the first launch player start with first half and then if you click the second half title from table view you will launch to the second half.

Business Logic Specs

* At launch you will be see matchId text field. And inside of it there is an id called 25199. If you try to enter another one it will give alert. Cause i figure it out that when you enter a different id you have to be logged in so i add a condition for that.
* With matchId i send the request and after that i fill my model.
* First half and second half are playing sequentially when first half is finish second half starts immediately. 
* Video title are in the list and it only appears in portrait mode. 
* In full screen mode user only play with the buttons of AVPlayer.

Extras

* I use UIViewControllerTransitionCoordinator for detecting which orientation mode the user having right now.
* I use NotificationCenter.default for receiving a notification when the player did end to play time so that i can change the videoUrl for secondHalf.
* I use addPeriodicTimeObserver this method for getting the current time and total duration of a match. Also it is for the sliders progress.
* I use NSLayoutConstraint.activate for the constraints.
* I use loadView method for the entire screen.
* I add back and next buttons on to AVPlayer. It is moving the player 5 seconds forward and back. Like youtube did.
* I am not a designer so maybe the design perspective is less but i try to do my best.

