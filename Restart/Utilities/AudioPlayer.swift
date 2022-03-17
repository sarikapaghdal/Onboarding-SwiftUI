//
//  AudioPlayer.swift
//  Restart
//
//  Created by Sarika on 17.03.22.
//

import Foundation
import AVFoundation

var audioPlayer : AVAudioPlayer?

func playSound (sound: String, Type : String) { //filename and file extension as a parameter
    if let path = Bundle.main.path(forResource: sound, ofType: Type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not play the sound file")
        }
    }
    
}
