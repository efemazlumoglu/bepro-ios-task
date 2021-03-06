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
    
    static let shared = ViewController()
    var disposeBag = DisposeBag()
    
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
    var minutes:Int = 0
    var seconds:Int = 0
    
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
    lazy var timePicker = UIPickerView()
    var tableView: UITableView!
    public let videoPlayer = StreamingVideoPlayer()
    
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
            if (ViewModel.shared.firstHalfVideoUrl != "") {
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
        self.timePicker.delegate = self
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
        matchIdTextField.text = String(describing: ViewModel.shared.matchId)
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
    
    // MARK: Setup Video Player method.
    public func setupVideoPlayer() { // calling the streaming video player class method
        videoPlayer.add(to: self.playerView)
    }
    
}
