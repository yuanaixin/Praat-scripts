# Sam Kirkham 2015
# Praat: downsample by specified number (will also filter at fs/2)
# Place script in same directory as sound files you want to filter
# WILL OVERWRITE YOUR FILES UNLESS YOU TELL IT TO RE-NAME THEM


form Downsample sound files
	word sound_extension .wav
	natural downsample enter number here
	comment Do you want to overwrite the original files or save as new files?
		choice option:
			button Overwrite original files
			button Re-name and save as new
endform

clearinfo

mySounds = Create Strings as file list... sounds *'sound_extension$'
nSounds = Get number of strings

for iSound to nSounds
	select mySounds
	sound$ = Get string... iSound
	name$ = sound$ - sound_extension$
		
	mySound = Read from file... 'sound$'

	endeditor

	select mySound

	# Filters at 70Hz and 11000Hz, smoothing = 100Hz (default)
	Filter (pass Hann band)... 0 downsample/2 100

	# Convert sampling rate to specific number (50 = Precision, default)
	Resample... downsample 50
	
	# Option to overwrite existing files or re-name according to sampling rate
	if option$ = "Overwrite original files"
		Write to WAV file... 'name$'.wav
	elsif option$ = "Re-name and save as new"
		Write to WAV file... 'name$'_'downsample'.wav
	endif

endfor


