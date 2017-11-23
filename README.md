# MIDIPlayer

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://en.wikipedia.org/wiki/MIT_License)
[![Build Status](https://travis-ci.org/genedelisa/MIDIPlayer.svg)](https://travis-ci.org/genedelisa/MIDIPlayer)
[![GitHub tag](https://img.shields.io/github/tag/genedelisa/MIDIPlayer.svg)](https://github.com/genedelisa/MIDIPlayer/)
[![GitHub release](https://img.shields.io/github/release/genedelisa/MIDIPlayer.svg)](https://github.com/genedelisa/MIDIPlayer/)
[![GitHub commits](https://img.shields.io/github/commits-since/genedelisa/MIDIPlayer/2.0.0.svg)
[![Swift 4](https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat")](https://developer.apple.com/swift)


[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://swift.org/)

[![Sponsors](https://img.shields.io/badge/Sponsors-Rockhopper%20Technologies-orange.svg?style=flat)](http://www.rockhoppertech.com/)
[![Twitter @GeneDeLisaDev](https://img.shields.io/twitter/follow/GeneDeLisaDev.svg?style=social)](https://twitter.com/GeneDeLisaDev)



Using AVMIDIPlayer from a MIDI file, and from a MusicSequence.

Neither SoundFonts nor DLS files will play in the simulator. They play on the device though.

Playing the "data" option takes a long time for the night on bald mountain file to be parsed.

It seems that tempo events cause the player to hiccup on the device.

## SoundFonts

Download your own SoundFont. You can get some here:

[MuseCore](http://musescore.org/en/handbook/soundfont)

You have to play it on a device to hear the sounds. Otherwise, in the simultor you will get just sine waves.

## Blog post for this example.

[Blog post](http://www.rockhoppertech.com/blog/swift-and-avmidiplayer)



## Bugs

Some goofiness when you move the slider. I want it to change when the slider is done.
I specified that in the storyboard. But, it still gets called while sliding.

Using MusicTrack in Swift is still a pain. I have idea what to do about MIDIMetaEvent - especially the data field. I think they imported it into Swift incorrectly. So, I don't have any meta events.

[![GitHub issues](https://img.shields.io/github/issues/genedelisa/MIDIPlayer.svg)](https://github.com/genedelisa/MIDIPlayer/issues)

If you find one, [please add it to issues](https://github.com/genedelisa/MIDIPlayer/issues)


### Buy my kitty Giacomo some cat food

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=F5KE9Z29MH8YQ&bnP-DonationsBF:btn_donate_SM.gif:NonHosted)

<img src="http://www.rockhoppertech.com/blog/wp-content/uploads/2016/07/momocoding-1024.png" alt="Giacomo Kitty" width="400" height="300">

## Licensing

[MIT](https://en.wikipedia.org/wiki/MIT_License)

Please read the [LICENSE](LICENSE) for details.

## Credits

*    [Gene De Lisa's development blog](http://rockhoppertech.com/blog/)
*    [Gene De Lisa's music blog](http://genedelisa.com/)
*   Twitter: [@GeneDeLisaDev](http://twitter.com/genedelisadev)

