//
//  ViewController.swift
//  MIDIPlayer
//
//  Created by Gene De Lisa on 9/10/14.
//  Copyright (c) 2014 Gene De Lisa. All rights reserved.
//

// updated to Swift 4

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // this one is from a midi file
    var midiPlayer: AVMIDIPlayer?
    
    // this one is from a sequence turned into data
    var midiPlayerFromData: AVMIDIPlayer?
    
    var musicPlayer: MusicPlayer?
    var soundbank: URL?
    let soundFontMuseCoreName = "GeneralUser GS MuseScore v1.442"
    let gMajor = "sibeliusGMajor"
    let nightBaldMountain = "ntbldmtn"
    
    var musicSequence: MusicSequence!
    
    @IBOutlet var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.musicSequence = createMusicSequence()
        createAVMIDIPlayer(self.musicSequence)
        createAVMIDIPlayerFromMIDIFIle()
        self.musicPlayer = createMusicPlayer(musicSequence)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func playData(_ sender: AnyObject) {
        self.midiPlayerFromData?.play({ () -> Void in
            print("finished")
            self.midiPlayerFromData?.currentPosition = 0
        })
    }
    
    @IBAction func play(_ sender: AnyObject) {
        self.midiPlayer?.play({ () -> Void in
            print("finished")
            self.midiPlayer?.currentPosition = 0
        })
    }
    
    @IBAction func playMusicSequence(_ sender: AnyObject) {
        playMusicPlayer()
    }
    
    @IBAction func stopPlaying(_ sender: AnyObject) {
        if let player = self.midiPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        if let player = self.midiPlayerFromData {
            if player.isPlaying {
                player.stop()
            }
        }
    }
    
    
    func createAVMIDIPlayer(_ musicSequence: MusicSequence) {
        
        guard let bankURL = Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2") else {
            fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
        }
        
        
        var status = noErr
        var data: Unmanaged<CFData>?
        status = MusicSequenceFileCreateData (musicSequence,
                                              MusicSequenceFileTypeID.midiType,
                                              MusicSequenceFileFlags.eraseFile,
                                              480, &data)
        
        if status != noErr {
            print("bad status \(status)")
        }
        
        if let md = data {
            let midiData = md.takeUnretainedValue() as Data
            do {
                try self.midiPlayerFromData = AVMIDIPlayer(data: midiData as Data, soundBankURL: bankURL)
                print("created midi player with sound bank url \(bankURL)")
            } catch let error as NSError {
                print("nil midi player")
                print("Error \(error.localizedDescription)")
            }
            data?.release()
            
            self.midiPlayerFromData?.prepareToPlay()
        }
        
    }
    
    func createAVMIDIPlayerFromMIDIFIle() {
        
        guard let midiFileURL = Bundle.main.url(forResource: nightBaldMountain, withExtension: "mid") else {
            fatalError("\"nightBaldMountain.mid\" file not found.")
        }
//        guard let midiFileURL = Bundle.main.url(forResource: "sibeliusGMajor", withExtension: "mid") else {
//            fatalError("\"sibeliusGMajor.mid\" file not found.")
//        }
        
        guard let bankURL = Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2") else {
            fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
        }
        
        do {
            try self.midiPlayer = AVMIDIPlayer(contentsOf: midiFileURL, soundBankURL: bankURL)
            print("created midi player with sound bank url \(bankURL)")
        } catch let error {
            print("Error \(error.localizedDescription)")
        }
        
        self.midiPlayer?.prepareToPlay()
        setupSlider()
    }
    
    func playWithMusicPlayer() {
        self.musicPlayer = createMusicPlayer(self.musicSequence)
        playMusicPlayer()
    }
    
    func createMusicPlayer(_ musicSequence: MusicSequence) -> MusicPlayer {
        var musicPlayer: MusicPlayer? = nil
        var status = noErr
        status = NewMusicPlayer(&musicPlayer)
        if status != noErr {
            print("bad status \(status) creating player")
        }
        status = MusicPlayerSetSequence(musicPlayer!, musicSequence)
        if status != noErr {
            print("setting sequence \(status)")
        }
        status = MusicPlayerPreroll(musicPlayer!)
        if status != noErr {
            print("prerolling player \(status)")
        }
        return musicPlayer!
    }
    
    func playMusicPlayer() {
        var status = noErr
        var playing = DarwinBoolean(false)
        status = MusicPlayerIsPlaying(musicPlayer!, &playing)
        if playing != false {
            print("music player is playing. stopping")
            status = MusicPlayerStop(musicPlayer!)
            if status != noErr {
                print("Error stopping \(status)")
                return
            }
        } else {
            print("music player is not playing.")
        }
        
        status = MusicPlayerSetTime(musicPlayer!, 0)
        if status != noErr {
            print("setting time \(status)")
            return
        }
        
        status = MusicPlayerStart(musicPlayer!)
        if status != noErr {
            print("Error starting \(status)")
            return
        }
    }
    
    
    
    func createMusicSequence() -> MusicSequence {
        // create the sequence
        var musicSequence: MusicSequence?
        var status = NewMusicSequence(&musicSequence)
        if status != noErr {
            print(" bad status \(status) creating sequence")
        }
        
        var tempoTrack: MusicTrack?
        if MusicSequenceGetTempoTrack(musicSequence!, &tempoTrack) != noErr {
            assert(tempoTrack != nil, "Cannot get tempo track")
        }
        //MusicTrackClear(tempoTrack, 0, 1)
        if MusicTrackNewExtendedTempoEvent(tempoTrack!, 0.0, 128.0) != noErr {
            print("could not set tempo")
        }
        if MusicTrackNewExtendedTempoEvent(tempoTrack!, 4.0, 256.0) != noErr {
            print("could not set tempo")
        }
        
        
        // add a track
        var track: MusicTrack?
        status = MusicSequenceNewTrack(musicSequence!, &track)
        if status != noErr {
            print("error creating track \(status)")
        }
        
        // bank select msb
        var chanmess = MIDIChannelMessage(status: 0xB0, data1: 0, data2: 0, reserved: 0)
        status = MusicTrackNewMIDIChannelEvent(track!, 0, &chanmess)
        if status != noErr {
            print("creating bank select event \(status)")
        }
        // bank select lsb
        chanmess = MIDIChannelMessage(status: 0xB0, data1: 32, data2: 0, reserved: 0)
        status = MusicTrackNewMIDIChannelEvent(track!, 0, &chanmess)
        if status != noErr {
            print("creating bank select event \(status)")
        }
        
        // program change. first data byte is the patch, the second data byte is unused for program change messages.
        chanmess = MIDIChannelMessage(status: 0xC0, data1: 0, data2: 0, reserved: 0)
        status = MusicTrackNewMIDIChannelEvent(track!, 0, &chanmess)
        if status != noErr {
            print("creating program change event \(status)")
        }
        
        // now make some notes and put them on the track
        var beat: MusicTimeStamp = 0.0
        for i: UInt8 in 60...72 {
            var mess = MIDINoteMessage(channel: 0,
                                       note: i,
                                       velocity: 64,
                                       releaseVelocity: 0,
                                       duration: 1.0 )
            status = MusicTrackNewMIDINoteEvent(track!, beat, &mess)
            if status != noErr {
                print("creating new midi note event \(status)")
            }
            beat += 1
        }
        
        CAShow(UnsafeMutablePointer<MusicSequence>(musicSequence!))
        
        return musicSequence!
    }
    
    
    
    // slider frobs from here to the end. just for the the file player.
    
    var sliderTimer: Timer?
    
    func setupSlider() {
        sliderTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                           target: self,
                                           selector: #selector(updateSlider),
                                           userInfo: nil,
                                           repeats: true)
        
        if let duration = midiPlayer?.duration {
            slider.maximumValue = Float(duration)
            slider.value = 0.0
            print("duration \(duration)")
        }
        slider.addTarget(self, action: #selector(sliderChanged(sender:)), for: .valueChanged)
    }
    
    @objc func updateSlider() {
        if let player = self.midiPlayer {
            slider.value = Float(player.currentPosition)
        }
    }
    
    
    @IBAction func sliderChanged(sender: UISlider) {
        sliderTimer?.invalidate()
        
        if let player = self.midiPlayer {
            player.stop()
            player.currentPosition = TimeInterval(sender.value)
            player.prepareToPlay()
            setupSlider()
            player.play(nil)
        }
    }
    
}
