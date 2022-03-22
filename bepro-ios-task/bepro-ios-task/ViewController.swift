//
//  ViewController.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import UIKit
import Foundation
import AVFoundation
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var matchId: Int = 25199 // when you put other id here it will need a logged in user
    var firstHalfVideoUrl: String = ""
    var secondHalfVideoUrl: String = ""
    var matchVideo: MatchVideo?
    var data: [Datum]?
    let disposeBag = DisposeBag()
    var firstHalfData: Datum?
    var secondHalfData: Datum?
    var firstHalfVideo: Video?
    var secondHalfVideo: Video?
    
    var firstHalfVideoTitle: String = ""
    var secondHalfVideoTitle: String = ""
    var videoURL: String = ""
    
    var listOfOptions: [String] = ["First Half", "Second Half"]
    
    var hideTableViewBool: Bool = true
    var contentViewHideBool: Bool = true
    var progressBarHideBool: Bool = true
    var isPortraitBool: Bool = true
    var isLandscapeBool: Bool = false
    var playerViewHideBool: Bool = true
    
    
    var portraitHeight: CGFloat = 0
    var portraitWidth: CGFloat = 0
    var portraitCenterY: CGFloat = 0
    let seekDuration: Float64 = 5
    
    lazy var infoLabel = UILabel() // i use lazy var cause a property whose initial value is not calculated until the first time it's called.
    lazy var totalTime = UILabel()
    lazy var currentTime = UILabel()
    lazy var activityIndicator = UIActivityIndicatorView()
    lazy var playerView = UIView()
    lazy var contentView = UIView()
    lazy var toogleFullScreenButton = UIButton()
    lazy var playButton = UIButton()
    lazy var pauseButton = UIButton()
    lazy var nextButton = UIButton()
    lazy var backButton = UIButton()
    lazy var matchIdTextField = UITextField()
    lazy var progressView = UISlider()
    var tableView: UITableView!
    private let videoPlayer = StreamingVideoPlayer()
    
    //MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) { // this for at the launch it will always open at portrait mode
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(false)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
        self.portraitHeight = self.view.bounds.height
        self.portraitWidth = self.view.bounds.width
        self.portraitCenterY = self.view.center.y
    }
    
    //MARK: viewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) { // to detect of the interface orientation of screen
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            isLandscapeBool = true
            isPortraitBool = false
            hideTableViewBool = true
            contentViewHideBool = true
            playerViewHideBool = false
            progressBarHideBool = true
            loadView()
        } else if UIDevice.current.orientation.isPortrait {
            isPortraitBool = true
            isLandscapeBool = false
            if (self.firstHalfVideoUrl != "") {
                hideTableViewBool = false
                contentViewHideBool = false
                playerViewHideBool = false
                progressBarHideBool = false
            }
            loadView()
        }
    }
    
    // MARK: SupportedInterfaceOrientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    //MARK: LoadView
    override func loadView() { // since we are not usign storyboards loadView is the first priority method that ios application life cycle so i used it
        super.loadView()
        //MARK: Notification Center Observer
        NotificationCenter.default.addObserver(self, selector: #selector(playingFinished), name: Notification.Name("PlayingFinished"), object: nil) // get the notif from video player of video is finished
        
        //MARK: Info Label
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.text = "Please enter the match id into the below text field. And from keyboard please click 'Done' to get match video."
        infoLabel.font = .boldSystemFont(ofSize: 15)
        infoLabel.numberOfLines = 3
        infoLabel.frame.size.height = 50
        self.view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([ // this layout constraint is used for constraints for the elements of view
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            infoLabel.heightAnchor.constraint(equalTo: infoLabel.heightAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        //MARK: MatchIdTextField
        self.matchIdTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 44))
        matchIdTextField.placeholder = "Enter Match Id Here"
        matchIdTextField.font = UIFont.systemFont(ofSize: 15)
        matchIdTextField.text = String(matchId)
        matchIdTextField.borderStyle = UITextField.BorderStyle.roundedRect
        matchIdTextField.layer.borderWidth = 1
        matchIdTextField.autocorrectionType = UITextAutocorrectionType.no
        matchIdTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        matchIdTextField.returnKeyType = UIReturnKeyType.done
        matchIdTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        matchIdTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        matchIdTextField.delegate = self
        matchIdTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(matchIdTextField)
        
        NSLayoutConstraint.activate([ // this layout constraint is used for constraints for the elements of view
            matchIdTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            matchIdTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            matchIdTextField.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor),
            matchIdTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        //MARK: PlayerView
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.isHidden = playerViewHideBool
        playerView.layer.cornerRadius = 20
        self.view.addSubview(playerView)
        
        //MARK: Next and Back Buttons
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = .white.withAlphaComponent(0)
        backButton.backgroundColor = .white.withAlphaComponent(0)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .allTouchEvents)
        backButton.addTarget(self, action: #selector(backTapped), for: .allTouchEvents)
        
        self.view.addSubview(nextButton)
        self.view.addSubview(backButton)
        
        if isPortraitBool { // this condition is for check if it is portrait or not and give constraints for related orientation
            NSLayoutConstraint.activate([
                playerView.topAnchor.constraint(equalTo: matchIdTextField.bottomAnchor, constant: 10),
                playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                playerView.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor, constant: 206),
                playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                backButton.topAnchor.constraint(equalTo: playerView.topAnchor),
                backButton.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
                backButton.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
                backButton.widthAnchor.constraint(equalToConstant: 120),
                nextButton.topAnchor.constraint(equalTo: playerView.topAnchor),
                nextButton.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
                nextButton.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
                nextButton.widthAnchor.constraint(equalToConstant: 120)
            ])
            
            videoPlayer.playerViewController.showsPlaybackControls = false
        } else {
            NSLayoutConstraint.activate([
                playerView.topAnchor.constraint(equalTo: view.topAnchor),
                playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backButton.topAnchor.constraint(equalTo: playerView.topAnchor),
                backButton.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
                backButton.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
                backButton.widthAnchor.constraint(equalToConstant: 150),
                nextButton.topAnchor.constraint(equalTo: playerView.topAnchor),
                nextButton.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
                nextButton.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
                nextButton.widthAnchor.constraint(equalToConstant: 150)
            ])
            
            videoPlayer.playerViewController.entersFullScreenWhenPlaybackBegins = true
            videoPlayer.playerViewController.showsPlaybackControls = true
            videoPlayer.playerViewController.modalPresentationStyle = .fullScreen
        }
        
        //MARK: TotalTime, CurrenTime and ProgressView
        totalTime.translatesAutoresizingMaskIntoConstraints = false
        currentTime.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.tintColor = .systemBlue
        progressView.isHidden = progressBarHideBool
        progressView.isContinuous = true
        progressView.addTarget(self, action: #selector(progressViewChanged), for: .valueChanged)
        progressView.backgroundColor = .systemGray3
        progressView.translatesAutoresizingMaskIntoConstraints = false
        // addPeriodicTimeObserver helps us to get current time of the videplayer and also the total time. For creating progress view.
        videoPlayer.avPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil) { time in
            if let duration = self.videoPlayer.avPlayer.currentItem?.duration {
                self.totalTime.text = duration.displayTime // for displayTime please look for the CMTimeExt extension
                self.currentTime.text = self.videoPlayer.avPlayer.currentItem?.currentTime().displayTime
                
                let seconds = CMTimeGetSeconds(time) // get seconds from time
                let durationSeconds = CMTimeGetSeconds(duration) // get the duration seconds
                self.progressView.value = Float(seconds / durationSeconds) // slider value is between 0 - 1 so this calc is necessary
            }
        }
        
        self.view.addSubview(totalTime)
        self.view.addSubview(currentTime)
        self.view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            currentTime.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 5),
            currentTime.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            totalTime.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 5),
            totalTime.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            progressView.topAnchor.constraint(equalTo: currentTime.bottomAnchor, constant: 15),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        //MARK: ContentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.isHidden = contentViewHideBool
        self.view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 15),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.heightAnchor.constraint(equalTo: playerView.heightAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // MARK: PlayButton
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playTapped), for: .allTouchEvents)
        playButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
        playButton.setTitleColor(UIColor.white, for: .normal)
        playButton.layer.cornerRadius = 15
        playButton.setTitle("Play", for: .normal)
        self.contentView.addSubview(playButton)
        
        // MARK: ToogleFullScreenButton
        toogleFullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        toogleFullScreenButton.addTarget(self, action: #selector(openFullScreen), for: .allTouchEvents)
        toogleFullScreenButton.backgroundColor = .systemGreen
        toogleFullScreenButton.setTitleColor(.white, for: .normal)
        toogleFullScreenButton.layer.cornerRadius = 15
        toogleFullScreenButton.setTitle("Full", for: .normal)
        self.contentView.addSubview(toogleFullScreenButton)
        
        //MARK: PauseButton
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .allTouchEvents)
        pauseButton.backgroundColor = UIColor.systemOrange
        pauseButton.setTitleColor(UIColor.white, for: .normal)
        pauseButton.layer.cornerRadius = 15
        pauseButton.setTitle("Pause", for: .normal)
        self.contentView.addSubview(pauseButton)
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            playButton.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor, constant: 10),
            playButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            playButton.widthAnchor.constraint(equalToConstant: 140),
            
            toogleFullScreenButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            toogleFullScreenButton.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor, constant: 10),
            toogleFullScreenButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 10),
            
            pauseButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            pauseButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            pauseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pauseButton.widthAnchor.constraint(equalToConstant: 140),
            
            toogleFullScreenButton.trailingAnchor.constraint(equalTo: pauseButton.leadingAnchor, constant: -10),
        ])
        
        //MARK: TableView
        let myTableView = UITableView()
        myTableView.frame = CGRect(x: 0, y: self.portraitCenterY + 120, width: self.portraitWidth, height: self.portraitHeight - 402) // you have give frame for the table view to add into the view
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = .white
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // register a tableview cell. A default one i choose.
        myTableView.allowsSelection = true
        myTableView.allowsMultipleSelection = false // i do not want users can able to select multiple cells.
        myTableView.isHidden = hideTableViewBool
        self.tableView = myTableView // this is how you create a table view inside loadview otherwise you cannot add tableview as a uiview into the view.
        self.view.addSubview(self.tableView)
        
        self.tableView.reloadData()
        
        //MARK: Activity Indicator and Blur Effect
        if (!activityIndicator.isHidden) { // this condition is for the ui when the request is sending if you press play button
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.startAnimating()
            activityIndicator.color = UIColor.white
            activityIndicator.style = .large
            self.view.addSubview(activityIndicator)
            self.view.bringSubviewToFront(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.widthAnchor.constraint(equalToConstant: 50),
                activityIndicator.heightAnchor.constraint(equalToConstant: 50),
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        
        //MARK: Video player setting up
        setupVideoPlayer() // videoPlayerSetup go to the StreamingVideoPlayer class to see
        
    }
    
    // MARK: Playing Finished Selector.
    @objc func playingFinished() { // this is for second half is opening sequentially
        if videoURL == "First Half" {
            var fileUrl = URL(string: self.firstHalfVideoUrl)!
            videoURL = "Second Half"
            fileUrl = URL(string: self.secondHalfVideoUrl)!
            self.videoPlayer.play(url: fileUrl)
        }
    }
    
    //MARK: Progress View Changed
    @objc func progressViewChanged() {
        
        if let duration = videoPlayer.avPlayer.currentItem?.duration {
            
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(self.progressView.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            videoPlayer.avPlayer.seek(to: seekTime, completionHandler: {
                completed in
                //
            })
        }
    }
    
    //MARK: Play Tapped selector
    @objc func playTapped() {
        self.matchIdTextField.resignFirstResponder()
        if (self.firstHalfVideoUrl == "" && self.secondHalfVideoUrl == "") { // this condition is for not to send request again and again
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            self.pauseButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(1)
            self.playButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            loadView() // i called this method to re render the view
        } else {
            self.pauseButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(1)
            self.playButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            let t1 = Float(videoPlayer.avPlayer.currentTime().value)
            let t2 = Float(videoPlayer.avPlayer.currentTime().timescale)
            let currentSeconds = t1 / t2
            self.videoPlayer.playPause(cmTime: CMTime(seconds: Double(currentSeconds), preferredTimescale: .max)) // this method is for paused player to seek the where it is left in the video player as seconds.
        }
    }
    
    //MARK: PauseTapped Selector
    @objc func pauseTapped() {
        self.matchIdTextField.resignFirstResponder()
        videoPlayer.pause()
        self.playButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(1)
        self.pauseButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.4)
        playButton.isUserInteractionEnabled = true
        pauseButton.isUserInteractionEnabled = false
    }
    
    //MARK: Open Full Screen Selector
    @objc func openFullScreen() { // for opening in full screen mode i changed the interface orientation to landscape cause i did this functionality for that
        self.matchIdTextField.resignFirstResponder()
        UIView.setAnimationsEnabled(false)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
    
    //MARK: Next Tapped Function
    @objc func nextTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { // animation for next button changes
            self.nextButton.setTitle(">>>", for: .normal)
            self.nextButton.backgroundColor = .systemGray2.withAlphaComponent(0.5)
            self.nextButton.setTitleColor(.systemRed, for: .normal)
        }
        self.matchIdTextField.resignFirstResponder()
        guard let duration  = videoPlayer.avPlayer.currentItem?.duration else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(videoPlayer.avPlayer.currentTime())
        let newTime = playerCurrentTime + seekDuration

        if newTime < CMTimeGetSeconds(duration) {

            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            videoPlayer.avPlayer.seek(to: time2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { // that is used cause the screen show at least 1 second more.
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    self.nextButton.setTitle("", for: .normal)
                    self.nextButton.backgroundColor = .white.withAlphaComponent(0)
                }
            }
        } else {
            if (videoURL != "Second Half") {
                var fileUrl = URL(string: self.firstHalfVideoUrl)!
                videoURL = "Second Half"
                fileUrl = URL(string: self.secondHalfVideoUrl)!
                self.videoPlayer.play(url: fileUrl)
                self.nextButton.setTitle("", for: .normal)
            }
        }
    }
    
    //MARK: Back Tapped Function
    @objc func backTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { // animation for back button changes
            self.backButton.setTitle("<<<", for: .normal)
            self.backButton.setTitleColor(.systemRed, for: .normal)
            self.backButton.backgroundColor = .systemGray2.withAlphaComponent(0.5)
        }
        self.matchIdTextField.resignFirstResponder()
        let playerCurrentTime = CMTimeGetSeconds(videoPlayer.avPlayer.currentTime())
        var newTime = playerCurrentTime - seekDuration

        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        videoPlayer.avPlayer.seek(to: time2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { // that is used cause the screen show at least 1 second more.
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.backButton.setTitle("", for: .normal)
                self.backButton.backgroundColor = .white.withAlphaComponent(0)
            }
        }
    }
    
    // MARK: Call Halfs Method
    func callHalfs(halfOption: String) { // for first half and second halfs of the game
        if (self.firstHalfVideoUrl == "" && self.secondHalfVideoUrl == "") {
            let alert = UIAlertController(title: "Warning", message: "Video url cannot found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            var fileUrl = URL(string: self.firstHalfVideoUrl)!
            if halfOption == "First Half" {
                videoURL = "First Half"
                fileUrl = URL(string: self.firstHalfVideoUrl)!
            } else {
                videoURL = "Second Half"
                fileUrl = URL(string: self.secondHalfVideoUrl)!
            }
            self.videoPlayer.play(url: fileUrl)
            self.progressView.value = 0
            self.pauseButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(1)
            self.playButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
        }
    }
    
    // MARK: Setup Video Player method.
    private func setupVideoPlayer() { // calling the streaming video player class method
        videoPlayer.add(to: self.playerView)
    }
    
    //MARK: RequestSend method.
    private func requestSend() { // rx call api
        
        playButton.isUserInteractionEnabled = false
        pauseButton.isUserInteractionEnabled = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        let client = APIClient.shared
        do {
            try client.getMatchVideo(matchId: self.matchId).subscribe(
                onNext: {
                    result in
                    
                    self.matchVideo = result
                    self.data = self.matchVideo?.getData()
                    
                    self.firstHalfData = self.data![0]
                    self.secondHalfData = self.data![1]
                    
                    self.firstHalfVideo = self.firstHalfData?.video
                    self.secondHalfVideo = self.secondHalfData?.video
                    
                    self.firstHalfVideoTitle = self.firstHalfVideo!.title
                    self.secondHalfVideoTitle = self.secondHalfVideo!.title
                    
                    self.firstHalfVideoUrl = self.firstHalfVideo!.servingURL
                    self.secondHalfVideoUrl = self.secondHalfVideo!.servingURL
                    
                    DispatchQueue.main.async { // ui updates must be on main thread
                        self.videoURL = "First Half"
                        self.callHalfs(halfOption: "First Half")
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.hideTableViewBool = false
                        self.contentViewHideBool = false
                        self.playerViewHideBool = false
                        self.progressBarHideBool = false
                        self.loadView()
                        self.tableView.reloadData()
                    }
                    
                }, onError: {
                    error in
                    print("error inside view controller: ", error)
                }, onCompleted: {
                    print("completed event")
                }).disposed(by: disposeBag)
        } catch {
            print(error)
        }
    }
    
}

//MARK: Extension for UITextField Delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let matchId: Int = Int(textField.text!)!
        self.matchId = matchId
        if matchId != 25199 {
            self.matchId = 25199
            textField.text = "25199"
            let alert = UIAlertController(title: "Warning", message: "If the match Id is not 25199 you have to be logged in", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            activityIndicator.isHidden = false
            hideTableViewBool = true
            contentViewHideBool = true
            playerViewHideBool = true
            progressBarHideBool = true
            activityIndicator.startAnimating()
            loadView()
            requestSend()
        }
        textField.resignFirstResponder()
        return true
    }
}

//MARK: ViewController extension for TableViewDelegate and Datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.listOfOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        var config = cell.defaultContentConfiguration() // when you are using default table view cell you have to use config cause textLabel etc is deprecated.
        if (data == "First Half") {
            config.text = self.firstHalfVideoTitle
        } else {
            config.text = self.secondHalfVideoTitle
        }
        if data == videoURL { // double check for you cannot click on the first half video title if you are already in the first half
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.listOfOptions[indexPath.row]
        if videoURL != data { //you cannot click on the first half video title if you are already in the first half
            self.callHalfs(halfOption: data)
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
