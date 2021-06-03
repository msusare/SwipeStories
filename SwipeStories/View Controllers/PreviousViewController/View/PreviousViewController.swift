//
//  PreviousViewController.swift
//  SwipeStories
//
//  Created by Mayur Susare on 02/06/21.
//

import UIKit
import AVKit

class PreviousViewController: UIViewController, SegmentedProgressBarDelegate  {
    
    //MARK:- OUTLETS
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    
    //
    //MARK:- Variables
    var pageIndex : Int = 0
    var items: [StoryDetails] = []
    var item: [Content] = []
    var SPB: SegmentedProgressBar!
    var player: AVPlayer!
    let loader = ImageLoader()
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        item = items[pageIndex].content
        
        SPB = SegmentedProgressBar(numberOfSegments: item.count, duration: 5)
        if #available(iOS 11.0, *) {
            SPB.frame = CGRect(x: 18, y: UIApplication.shared.statusBarFrame.height + 5, width: view.frame.width - 35, height: 3)
        } else {
            // Fallback on earlier versions
            SPB.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 3)
        }
        
        SPB.delegate = self
        SPB.topColor = UIColor.white
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        SPB.padding = 2
        SPB.isPaused = true
        SPB.currentAnimationIndex = 0
        SPB.duration = getDuration(at: 0)
        view.addSubview(SPB)
        view.bringSubviewToFront(SPB)
        setupGuesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.8) {
            self.view.transform = .identity
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.SPB.startAnimation()
            self.playVideoOrLoadImage(index: 0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.SPB.currentAnimationIndex = 0
            self.SPB.cancel()
            self.SPB.isPaused = true
            self.resetPlayer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Custom Methods
    func setupGuesture() {
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(tap:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        imagePreview.addGestureRecognizer(tapGestureImage)
        imagePreview.isUserInteractionEnabled = true
        
        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(tapOn(tap:)))
        tapGestureVideo.numberOfTapsRequired = 1
        tapGestureVideo.numberOfTouchesRequired = 1
        videoView.addGestureRecognizer(tapGestureVideo)
        videoView.isUserInteractionEnabled = true

    }
    
    //MARK: - SegmentedProgressBarDelegate

    //1
    func segmentedProgressBarChangedIndex(index: Int) {
        playVideoOrLoadImage(index: index)
    }
    
    //2
    func segmentedProgressBarFinished() {
        if pageIndex == (self.items.count - 1) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            ViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
        }
    }
    
    @objc func tapOn(tap: UITapGestureRecognizer) {
        print("Touch found")
        let point = tap.location(in: self.view)
        let leftArea = CGRect(x: 0, y: 0, width: view.bounds.width/2, height: view.bounds.height)
        if leftArea.contains(point) {
            print("Left Side Clicked")
            SPB.skip()
            //Your actions when you click on the left side of the screen
        } else {
            print("Right Side Clicked")
            SPB.skip()
            //Your actions when you click on the right side of the screen
        }
    }
    
    //MARK: - Play or show image
    func playVideoOrLoadImage(index: NSInteger) {
        resetPlayer()
        if item[index].type == "image" {
            self.SPB.duration = 5
            self.imagePreview.isHidden = false
            self.videoView.isHidden = true
            self.imagePreview.imageFromServerURL(item[index].url)
        } else {
            self.imagePreview.isHidden = true
            self.videoView.isHidden = false
            
            guard let url = NSURL(string: item[index].url) as URL? else {return}
            self.player = AVPlayer(url: url)
            player.isMuted = true

            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback, options: [])
                try audioSession.setActive(true)
                audioSession.addObserver(self, forKeyPath: "outputVolume",
                                         options: NSKeyValueObservingOptions.new, context: nil)
            } catch {
                print("Error")
            }
            
            let videoLayer = AVPlayerLayer(player: self.player)
            videoLayer.frame = view.bounds
            videoLayer.videoGravity = .resizeAspect
            self.videoView.layer.addSublayer(videoLayer)
            
            let asset = AVAsset(url: url)
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            
            self.SPB.duration = durationTime
            self.player.play()
        }
    }
    
    // MARK: Private func
    private func getDuration(at index: Int) -> TimeInterval {
        var retVal: TimeInterval = 5.0
        if item[index].type == "image" {
            retVal = 5.0
        } else {
            guard let url = NSURL(string: item[index].url) as URL? else { return retVal }
            let asset = AVAsset(url: url)
            let duration = asset.duration
            retVal = CMTimeGetSeconds(duration)
        }
        return retVal
    }
    
    private func resetPlayer() {
        if player != nil {
            player.pause()
            player.replaceCurrentItem(with: nil)
            player = nil
        }
    }
    
    //MARK: - Button actions
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        resetPlayer()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if keyPath == "outputVolume"{
            player.isMuted = false
        }
    }
}
