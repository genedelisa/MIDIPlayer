# MIDIPlayer

Using AVMIDIPlayer from a MIDI file, and from a MusicSequence.

SoundFonts nor DLS files will play in the simulator. They play on the device though.

Playing the "data" option takes a long time for the night on bald mountain file to be parsed.

It seems that tempo events cause the player to hiccup on the device.

## SoundFonts

Download your own SoundFont. You can get some here:

[MuseCore] (http://musescore.org/en/handbook/soundfont)

## Blog post for this example.

[Blog post](http://www.rockhoppertech.com/blog/)
soon


## Bugs

Some goofiness when you move the slider. I want it to change when the slider is done.
I specified that in the storyboard. But, it still gets called while sliding.

Using MusicTrack in Swift is still a pain. I have idea what to do about MIDIMetaEvent - especially the data field. I think they imported it into Swift incorrectly. So, I don't have any meta events.


## Licensing

I'd appreciate an ack somehow.

## Credits

*	[Gene De Lisa](http://rockhoppertech.com/blog/)