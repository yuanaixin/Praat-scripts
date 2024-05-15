# Sam Kirkham 2014 (LING327)
# Presents a series of sound files and accompanying TextGrids, allows you to edit the TextGrid
# and then when you press 'continue' it saves your changes and opens the next file
# Pressing stop will end the script, but anything you did before the last time you
# pressed 'continue' will be saved
# Run from the folder where the WAV and TextGrid files are located

form Press 'ok' to continue
	word sound_extension .wav
	word textGrid_extension .textGrid
endform

clearinfo

mySounds = Create Strings as file list... sounds *'sound_extension$'
nSounds = Get number of strings

for iSound to nSounds
	select mySounds
	sound$ = Get string... iSound
	name$ = sound$ - sound_extension$
	textGrid$ = name$ + textGrid_extension$
		
	mySound = Read from file... 'sound$'
	myTextGrid = Read from file... 'textGrid$'

	select mySound
	plus myTextGrid

	Edit
	
	pause

	endeditor
	
	select myTextGrid
	Write to text file... 'name$'.TextGrid

endfor



