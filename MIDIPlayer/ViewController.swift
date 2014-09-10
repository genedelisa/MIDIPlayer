//
//  ViewController.swift
//  MIDIPlayer
//
//  Created by Gene De Lisa on 9/10/14.
//  Copyright (c) 2014 Gene De Lisa. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var mp:AVMIDIPlayer?
    var soundbank:NSURL?
//    let soundFontPianoName = "acoustic_grand_piano_ydp_20080910"
    let soundFontMuseCoreName = "GeneralUser GS MuseScore v1.442"
    let gMajor = "sibeliusGMajor"
    let nightBaldMountain = "ntbldmtn" 
    @IBOutlet var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func playData(sender: AnyObject) {
        midiData()
    }
    
    @IBAction func play(sender: AnyObject) {
        midiFile()
    }
    
    @IBAction func playMusicSequence(sender: AnyObject) {
        playSequence()
    }
    
    @IBAction func stopPlaying(sender: AnyObject) {
        if let player = self.mp {
            if player.playing {
                player.stop()
            }
        }
    }
    
    // nope. the player crashes with this on play
    func completion() -> Void {
    }
    
    func midiFile() {
        var completion:AVMIDIPlayerCompletionHandler = {
            println("done")
        }
        
        if let contents = NSBundle.mainBundle().URLForResource(gMajor, withExtension: "mid") {
//            self.soundbank = NSBundle.mainBundle().URLForResource(soundFontMuseCoreName, withExtension: "sf2")
            self.soundbank = NSBundle.mainBundle().URLForResource("gs_instruments", withExtension: "dls")
            println("soundbank \(soundbank!)")
            if self.soundbank != nil {
                var error:NSError?
                self.mp = AVMIDIPlayer(contentsOfURL: contents, soundBankURL: soundbank!, error: &error)
                if(self.mp != nil) {
                    mp!.prepareToPlay()
                    // crashes if you set a completion handler
                    setupSlider()
                    mp!.play(nil)
                } else {
                    if let e = error {
                        println("Error \(e.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func midiData() {
        if let contents = NSBundle.mainBundle().URLForResource(nightBaldMountain, withExtension: "mid") {
            self.soundbank = NSBundle.mainBundle().URLForResource(soundFontMuseCoreName, withExtension: "sf2")
            if self.soundbank != nil {
                var data = NSData(contentsOfURL: contents)
                var error:NSError?
                self.mp = AVMIDIPlayer(data:data, soundBankURL: soundbank!, error: &error)
                if(self.mp != nil) {
                    mp!.prepareToPlay()
                    setupSlider()
                    mp!.play(nil)
                } else {
                    if let e = error {
                        println("Error \(e.localizedDescription)")
                    }
                }
            }
        }
        
    }
    
    func playSequence() {
        var sequence = createMusicSequence()
        var data = seqToData(sequence)
        self.soundbank = NSBundle.mainBundle().URLForResource(soundFontMuseCoreName, withExtension: "sf2")
        if self.soundbank != nil {
            var error:NSError?
            self.mp = AVMIDIPlayer(data:data, soundBankURL: soundbank!, error: &error)
            if(self.mp != nil) {
                mp!.prepareToPlay()
                setupSlider()
                mp!.play(nil)
            } else {
                if let e = error {
                    println("Error \(e.localizedDescription)")
                }
            }
        }
    }
    
    func createMusicSequence() -> MusicSequence {
        // create the sequence
        var musicSequence:MusicSequence = MusicSequence()
        var status = NewMusicSequence(&musicSequence)
        if status != OSStatus(noErr) {
            println("\(__LINE__) bad status \(status) creating sequence")
        }
        
        // add a track
        var track:MusicTrack = MusicTrack()
        status = MusicSequenceNewTrack(musicSequence, &track)
        if status != OSStatus(noErr) {
            println("error creating track \(status)")
        }
        
        // bank select msb
        var chanmess = MIDIChannelMessage(status: 0xB0, data1: 0, data2: 0, reserved: 0)
        status = MusicTrackNewMIDIChannelEvent(track, 0, &chanmess)
        if status != OSStatus(noErr) {
            println("creating bank select event \(status)")
        }
        // bank select lsb
        chanmess = MIDIChannelMessage(status: 0xB0, data1: 32, data2: 0, reserved: 0)
        status = MusicTrackNewMIDIChannelEvent(track, 0, &chanmess)
        if status != OSStatus(noErr) {
            println("creating bank select event \(status)")
        }
        
        // program change. first data byte is the patch, the second data byte is unused for program change messages.
        chanmess = MIDIChannelMessage(status: 0xC0, data1: 0, data2: 0, reserved: 0)
        status = MusicTrackNewMIDIChannelEvent(track, 0, &chanmess)
        if status != OSStatus(noErr) {
            println("creating program change event \(status)")
        }
        
        // now make some notes and put them on the track
        var beat:MusicTimeStamp = 0.0
        for i:UInt8 in 60...72 {
            var mess = MIDINoteMessage(channel: 0,
                note: i,
                velocity: 64,
                releaseVelocity: 0,
                duration: 1.0 )
            status = MusicTrackNewMIDINoteEvent(track, beat, &mess)
            if status != OSStatus(noErr) {
                println("creating new midi note event \(status)")
            }
            beat++
        }
        
        CAShow(UnsafeMutablePointer<MusicSequence>(musicSequence))
        
        return musicSequence
    }
    
    
    func seqToData(musicSequence:MusicSequence) -> NSData {
        var status = OSStatus(noErr)
        var data:Unmanaged<CFData>?
        status = MusicSequenceFileCreateData (musicSequence,
            MusicSequenceFileTypeID(kMusicSequenceFile_MIDIType),
            MusicSequenceFileFlags(kMusicSequenceFileFlags_EraseFile),
            480, &data)
        
        var ns:NSData = data!.takeRetainedValue()
        return ns
    }
    
    // slider frobs from here to the end
    
    var sliderTimer:NSTimer?
    
    func setupSlider() {
        sliderTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
            target:self,
            selector: "updateSlider",
            userInfo:nil,
            repeats:true)
        
        if let duration = mp?.duration {
            slider.maximumValue = Float(duration)
            slider.value = 0.0
            println("duration \(duration)")
        }
        slider.addTarget(self, action:"sliderChanged:", forControlEvents:.ValueChanged)
    }
    
    func updateSlider() {
        if let player = self.mp {
            slider.value = Float(player.currentPosition)
        }
    }
    
    
    @IBAction func sliderChanged(sender: UISlider) {
        sliderTimer?.invalidate()
        
        if let player = self.mp {
            player.stop()
            player.currentPosition = NSTimeInterval(sender.value)
            player.prepareToPlay()
            setupSlider()
            player.play(nil)
        }
    }
    
}

