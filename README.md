# MIDIPlayer

Using AVMIDIPlayer from a MIDI file, and from a MusicSequence.

Neither SoundFonts nor DLS files will play in the simulator. They play on the device though.

Playing the "data" option takes a long time for the night on bald mountain file to be parsed.

It seems that tempo events cause the player to hiccup on the device.

## SoundFonts

Download your own SoundFont. You can get some here:

[MuseCore] (http://musescore.org/en/handbook/soundfont)

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

If this project is of any use to you, my ravenous Maine Coon kitty would like a snack.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=F5KE9Z29MH8YQ&bnP-DonationsBF:btn_donate_SM.gif:NonHosted)

<img src="http://www.rockhoppertech.com/blog/wp-content/uploads/2015/05/IMG_0657.png" alt="Giacomo Kitty" width="400" height="300">


## Licensing

[MIT](https://en.wikipedia.org/wiki/MIT_License)

Please read the [LICENSE](LICENSE) for details.

## Credits

*	[Gene De Lisa's development blog](http://rockhoppertech.com/blog/)
*	[Gene De Lisa's music blog](http://genedelisa.com/)
*   Twitter: [@GeneDeLisaDev](http://twitter.com/genedelisadev)