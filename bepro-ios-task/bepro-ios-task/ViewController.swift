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
    
    
    var totalTime = UILabel()
    var currentTime = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    var playerView = UIView()
    var contentView = UIView()
    var toogleFullScreenButton = UIButton()
    var playButton = UIButton()
    var pauseButton = UIButton()
    var tableView: UITableView!
    var matchIdTextField = UITextField()
    var progressView = UIProgressView(progressViewStyle: UIProgressView.Style.bar)
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
            playerViewHideBool = true
            progressBarHideBool = true
            loadView()
        } else if UIDevice.current.orientation.isFlat {
            print("flat")
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
        } else if UIDevice.current.orientation.isValidInterfaceOrientation {
            //
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
        
        //MARK: MatchIdTextField
        self.matchIdTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 44))
        matchIdTextField.placeholder = "Enter Match Id Here"
        matchIdTextField.font = UIFont.systemFont(ofSize: 15)
        matchIdTextField.text = String(matchId)
        matchIdTextField.borderStyle = UITextField.BorderStyle.roundedRect
        matchIdTextField.layer.borderWidth = 1
        matchIdTextField.autocorrectionType = UITextAutocorrectionType.no
        matchIdTextField.keyboardType = UIKeyboardType.default
        matchIdTextField.returnKeyType = UIReturnKeyType.done
        matchIdTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        matchIdTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        matchIdTextField.delegate = self
        matchIdTextField.isHidden = false
        matchIdTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(matchIdTextField)
        
        NSLayoutConstraint.activate([ // this layout constraint is used for constraints for the elements of view
            matchIdTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            matchIdTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            matchIdTextField.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor),
            matchIdTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        //MARK: PlayerView
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.isHidden = playerViewHideBool
        playerView.layer.cornerRadius = 20
        self.view.addSubview(playerView)
        
        if isPortraitBool { // this condition is for check if it is portrait or not
            NSLayoutConstraint.activate([
                playerView.topAnchor.constraint(equalTo: matchIdTextField.bottomAnchor, constant: 10),
                playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                playerView.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor, constant: 206),
                playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                playerView.topAnchor.constraint(equalTo: view.topAnchor),
                playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            videoPlayer.playerViewController.entersFullScreenWhenPlaybackBegins = true
            videoPlayer.playerViewController.modalPresentationStyle = .fullScreen
        }
        
        //MARK: TotalTime, CurrenTime and ProgressView
        totalTime.translatesAutoresizingMaskIntoConstraints = false
        currentTime.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.progressTintColor = .systemBlue
        progressView.isHidden = progressBarHideBool
        progressView.backgroundColor = .systemGray3
        progressView.translatesAutoresizingMaskIntoConstraints = false
        // addPeriodicTimeObserver helps us to get current time of the videplayer and also the total time. For creating progress view.
        videoPlayer.avPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil) { time in
            let duration = CMTimeGetSeconds(self.videoPlayer.avPlayer.currentItem!.duration)
            self.totalTime.text = self.videoPlayer.avPlayer.currentItem!.duration.displayTime // for displayTime please look for the CMTimeExt extension
            self.currentTime.text = self.videoPlayer.avPlayer.currentItem?.currentTime().displayTime
            self.progressView.progress = Float((CMTimeGetSeconds(time) / duration))
        }
        self.view.addSubview(totalTime)
        self.view.addSubview(currentTime)
        self.view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            currentTime.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 5),
            currentTime.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            totalTime.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 5),
            totalTime.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            progressView.topAnchor.constraint(equalTo: currentTime.bottomAnchor, constant: 5),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        //MARK: ContentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.isHidden = contentViewHideBool
        self.view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.heightAnchor.constraint(equalTo: playerView.heightAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // MARK: PlayButton
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playTapped), for: .allTouchEvents)
        playButton.backgroundColor = UIColor.systemBlue
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
    
    //MARK: Play Tapped selector
    @objc func playTapped() {
        if (self.firstHalfVideoUrl == "" && self.secondHalfVideoUrl == "") { // this condition is for not to send request again and again
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            loadView() // i called this method to re render the view
        } else {
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            self.videoPlayer.playPause() // this method is for paused player to seek the where it is left in the video player as seconds.
        }
    }
    
    //MARK: PauseTapped Selector
    @objc func pauseTapped() {
        videoPlayer.pause()
        playButton.isUserInteractionEnabled = true
        pauseButton.isUserInteractionEnabled = false
    }
    
    //MARK: Open Full Screen Selector
    @objc func openFullScreen() { // for opening in full screen mode i changed the interface orientation to landscape cause i did this functionality for that
        UIView.setAnimationsEnabled(false)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
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
