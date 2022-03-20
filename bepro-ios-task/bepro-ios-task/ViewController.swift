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
    private let videoPlayer = StreamingVideoPlayer()
    let progressView = UIProgressView(progressViewStyle: UIProgressView.Style.bar)
    private var matchIdTextField = UITextField()
    public var activityIndicator = UIActivityIndicatorView()
    public var playerView = UIView()
    public var contentView = UIView()
    public var playButton = UIButton()
    public var pauseButton = UIButton()
    public var tableView: UITableView!
    
    override func loadView() { // since we are not usign storyboards loadView is the first priority method that ios application life cycle so i used it
        super.loadView()
        
        self.matchIdTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 44))
        matchIdTextField.placeholder = "Enter Match Id Here"
        matchIdTextField.font = UIFont.systemFont(ofSize: 15)
        matchIdTextField.text = String(matchId)
        matchIdTextField.borderStyle = UITextField.BorderStyle.roundedRect
        matchIdTextField.autocorrectionType = UITextAutocorrectionType.no
        matchIdTextField.keyboardType = UIKeyboardType.default
        matchIdTextField.returnKeyType = UIReturnKeyType.done
        matchIdTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        matchIdTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        matchIdTextField.delegate = self
        matchIdTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(matchIdTextField)
        
        NSLayoutConstraint.activate([ // this layout constraint is used for constraints for the elements of view
            matchIdTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            matchIdTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            matchIdTextField.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor),
            matchIdTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.layer.cornerRadius = 20
        self.view.addSubview(playerView)
        
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: matchIdTextField.bottomAnchor, constant: 30),
            playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerView.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor, constant: 186),
            playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        progressView.progressTintColor = .blue
        progressView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.isHidden = contentViewHideBool
        self.view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.heightAnchor.constraint(equalTo: playerView.heightAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playTapped), for: .allTouchEvents)
        playButton.backgroundColor = UIColor.systemBlue
        playButton.setTitleColor(UIColor.white, for: .normal)
        playButton.layer.cornerRadius = 15
        playButton.setTitle("Play", for: .normal)
        self.contentView.addSubview(playButton)
        
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .allTouchEvents)
        pauseButton.backgroundColor = UIColor.white
        pauseButton.setTitleColor(UIColor.blue, for: .normal)
        pauseButton.layer.cornerRadius = 15
        pauseButton.setTitle("Pause", for: .normal)
        self.contentView.addSubview(pauseButton)
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            playButton.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor, constant: 10),
            playButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            playButton.widthAnchor.constraint(equalToConstant: 140),
            
            pauseButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            pauseButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            pauseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pauseButton.widthAnchor.constraint(equalToConstant: 140)
        ])
        
        
        let myTableView = UITableView()
        myTableView.frame = CGRect(x: 0, y: view.center.y + 120, width: self.view.bounds.width, height: self.view.bounds.height - 402)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = .lightGray
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.allowsSelection = true
        myTableView.allowsMultipleSelection = false
        myTableView.isHidden = hideTableViewBool
        self.tableView = myTableView
        self.view.addSubview(self.tableView)
        
        self.tableView.reloadData()
        
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
        
        setupVideoPlayer() // videoPlayerSetup go to the StreamingVideoPlayer class to see
        
    }
    
    @objc func dismissKeyboard() {
        self.matchIdTextField.resignFirstResponder()
    }
    
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
    
    @objc func pauseTapped() {
        videoPlayer.pause()
        playButton.isUserInteractionEnabled = true
        pauseButton.isUserInteractionEnabled = false
    }
    
    func callHalfs(halfOption: String) {
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
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func requestSend() {
        
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
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.callHalfs(halfOption: "First Half")
                        self.videoURL = "First Half"
                        self.hideTableViewBool = false
                        self.contentViewHideBool = false
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
    
    private func setupVideoPlayer() {
        videoPlayer.add(to: self.playerView)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
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
            activityIndicator.startAnimating()
            loadView()
            requestSend()
        }
        // may be useful: textField.resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.listOfOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .blue
        var config = cell.defaultContentConfiguration()
        if (data == "First Half") {
            config.text = self.firstHalfVideoTitle
        } else {
            config.text = self.secondHalfVideoTitle
        }
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.listOfOptions[indexPath.row]
        playButton.isUserInteractionEnabled = false
        pauseButton.isUserInteractionEnabled = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if videoURL != data {
            self.callHalfs(halfOption: data)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
