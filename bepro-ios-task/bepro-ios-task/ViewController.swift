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
    
    var matchId: Int = 25199
    var firstHalfVideoUrl: String = ""
    var secondHalfVideoUrl: String = ""
    var matchVideo: MatchVideo?
    var data: [Datum]?
    let disposeBag = DisposeBag()
    var firstHalfData: Datum?
    var secondHalfData: Datum?
    var firstHalfVideo: Video?
    var secondHalfVideo: Video?
    var videoURL: URL?
    var listOfOptions: [String] = ["First Half", "Second Half"]
    private let generalView = UIScrollView()
    private let videoPlayer = StreamingVideoPlayer()
    private var matchIdTextField = UITextField()
    public var activityIndicator = UIActivityIndicatorView()
    public var playerView = UIView()
    public var playButton = UIButton()
    public var pauseButton = UIButton()
    public var tableView = UITableView()
    public var tableViewCell = UITableViewCell()
    
    override func loadView() {
        super.loadView()
        
        self.matchIdTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 44))
        matchIdTextField.placeholder = "Enter Match Id Here"
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
        
        NSLayoutConstraint.activate([
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
        pauseButton.backgroundColor = UIColor.red
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
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: pauseButton.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: pauseButton.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: pauseButton.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        if (!activityIndicator.isHidden) {
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
        
        setupVideoPlayer()
        
    }
    
    @objc func playTapped() {
        if (self.firstHalfVideoUrl == "" && self.secondHalfVideoUrl == "") {
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            loadView()
            requestSend()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.loadView()
                let fileUrl = URL(string: self.firstHalfVideoUrl)!
                self.videoPlayer.play(url: fileUrl)
            }
        } else {
            playButton.isUserInteractionEnabled = false
            pauseButton.isUserInteractionEnabled = true
            let fileUrl = URL(string: self.firstHalfVideoUrl)!
            self.videoPlayer.play(url: fileUrl)
        }
    }
    
    @objc func pauseTapped() {
        videoPlayer.pause()
        playButton.isUserInteractionEnabled = true
        pauseButton.isUserInteractionEnabled = false
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
                    
                    self.firstHalfVideoUrl = self.firstHalfVideo!.servingURL
                    self.secondHalfVideoUrl = self.secondHalfVideo!.servingURL
                    
                    self.videoURL = URL(string: "\(self.firstHalfVideoUrl)")
                    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}
