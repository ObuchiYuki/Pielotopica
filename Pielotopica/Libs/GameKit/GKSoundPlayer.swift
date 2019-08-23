//
//  GKSoundPlayer.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

public struct GKSoundFile {
    fileprivate let _filename:String
    fileprivate let _exp:String
    
    init(filename:String, exp:String="") {
        self._filename = filename
        self._exp = exp
    }
}

public class GKSoundPlayer {

    private var musicPlayer: AVAudioPlayer!
    private var soundPlayer: AVAudioPlayer!

    public static var canShareAudio = false {
        didSet {
            canShareAudio ? try! AVAudioSession.sharedInstance().setCategory(.ambient)
                : try! AVAudioSession.sharedInstance().setCategory(.soloAmbient)
        }
    }

    public static let shared = GKSoundPlayer()

    public func playMusic(_ file: GKSoundFile) {
        if let url = Bundle.main.url(forResource: file._filename, withExtension: file._exp) {
            musicPlayer = try? AVAudioPlayer(contentsOf: url)
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
    }

    public func stopMusic() {
        if musicPlayer != nil && musicPlayer!.isPlaying {
            musicPlayer.currentTime = 0
            musicPlayer.stop()
        }
    }

    public func pauseMusic() {
        if musicPlayer != nil && musicPlayer!.isPlaying {
            musicPlayer.pause()
        }
    }

    public func resumeMusic() {
        if musicPlayer != nil && !musicPlayer!.isPlaying {
            musicPlayer.play()
        }
    }

    public func playSoundEffect(_ file: GKSoundFile) {
        if let url = Bundle.main.url(forResource: file._filename, withExtension: file._exp) {
            soundPlayer = try? AVAudioPlayer(contentsOf: url)
            soundPlayer.stop()
            soundPlayer.numberOfLoops = 0
            soundPlayer.prepareToPlay()
            soundPlayer.play()
        }
    }
}
