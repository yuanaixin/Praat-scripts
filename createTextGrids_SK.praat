# Sam Kirkham 2014 (LING327)
# Takes a number of individual WAV files in a folder and adds a TextGrid
# TextGrid will have the same name as the WAV file
# You can specify the names of the tiers in the form box
# Tier names must be enclosed in quotation marks and separated by spaces; e.g. "vowel word speaker"
# Script must be run from the folder in which the sound files are located

form Enter your tier names in the box below (within the quote marks!)
	word sound_extension .wav
	word textGrid_extension .textGrid
	sentence tierNames "token phoneme"
endform

clearinfo

mySounds = Create Strings as file list... sounds *'sound_extension$'
nSounds = Get number of strings

for iSound to nSounds
	select mySounds
	sound$ = Get string... iSound
	name$ = sound$ - sound_extension$
	
	mySound = Read from file... 'sound$'

	select mySound
	
	textGrid = To TextGrid... 'tierNames$'
	Write to text file... 'name$'.TextGrid

endfor
