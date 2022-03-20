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
    var videoURL: URL?
    var listOfOptions: [String] = ["First Half", "Second Half"]
    private let generalView = UIScrollView()
    private let videoPlayer = StreamingVideoPlayer()
    private var matchIdTextField = UITextField()
    public var activityIndicator = UIActivityIndicatorView()
    public var playerView = UIView()
    public var playButton = UIButton()
    public var pauseButton = UIButton()
    public var tableView: UITableView!
    
    override func loadView() { // since we are not usign storyboards loadView is the first priority method that ios application life cycle so i used it
        super.loadView()
        
        self.matchIdTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 44))
        matchIdTextField.placeholder = "Enter Match Id Here"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        matchIdTextField.font = UIFont.systemFont(ofSize: 15)
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
            playerView.leadingAnchor.constraint(equalTo: matchIdTextField.leadingAnchor),
            playerView.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor, constant: 156),
            playerView.trailingAnchor.constraint(equalTo: matchIdTextField.trailingAnchor)
        ])
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playTapped), for: .allTouchEvents)
        playButton.backgroundColor = UIColor.systemBlue
        playButton.setTitleColor(UIColor.white, for: .normal)
        playButton.layer.cornerRadius = 15
        playButton.setTitle("Play", for: .normal)
        self.view.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 30),
            playButton.heightAnchor.constraint(equalTo: matchIdTextField.heightAnchor, constant: 10),
            playButton.leadingAnchor.constraint(equalTo: matchIdTextField.leadingAnchor),
            playButton.trailingAnchor.constraint(equalTo: matchIdTextField.trailingAnchor)
        ])
        
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .allTouchEvents)
        pauseButton.backgroundColor = UIColor.systemRed
        pauseButton.setTitleColor(UIColor.white, for: .normal)
        pauseButton.layer.cornerRadius = 15
        pauseButton.setTitle("Pause", for: .normal)
        self.view.addSubview(pauseButton)
        
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 30),
            pauseButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            pauseButton.leadingAnchor.constraint(equalTo: playButton.leadingAnchor),
            pauseButton.trailingAnchor.constraint(equalTo: playButton.trailingAnchor)
        ])
        
        let myTableView = UITableView()
        myTableView.frame = CGRect(x: 30, y: view.center.y + 100, width: self.view.bounds.width - 55, height: self.view.bounds.height - 472)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = .lightGray
        myTableView.layer.cornerRadius = 30
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.allowsSelection = true
        myTableView.allowsMultipleSelection = false
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
            
            activityIndicator.startAnimating()
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
            requestSend()
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
        self.videoPlayer.pause()
        if (self.firstHalfVideoUrl == "" && self.secondHalfVideoUrl == "") {
            // alert view cikart
        } else {
            var fileUrl = URL(string: self.firstHalfVideoUrl)!
            if halfOption == "First Half" {
                fileUrl = URL(string: self.firstHalfVideoUrl)!
            } else {
                fileUrl = URL(string: self.secondHalfVideoUrl)!
            }
            self.videoPlayer.play(url: fileUrl)
        }
    }
    
    private func requestSend() {
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
                    
                    self.videoURL = URL(string: "\(self.firstHalfVideoUrl)")
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.loadView()
                        let fileUrl = URL(string: self.firstHalfVideoUrl)!
                        self.videoPlayer.play(url: fileUrl)
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
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
        config.text = data
        if (data == "First Half") {
            config.secondaryText = self.firstHalfVideoTitle
        } else {
            config.secondaryText = self.secondHalfVideoTitle
        }
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.listOfOptions[indexPath.row]
        self.callHalfs(halfOption: data)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
