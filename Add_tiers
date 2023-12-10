# This script is modified from Claire Nance's add_tiers script by Aixin Yuan 
# updated in 2023-12-11
#
# [WHAT DOES IT DO TO THE TEXTGRIDS]
# This script will loop through all the files in a folder, and will add tiers to the textgrids
#
# [OUTPUT]
# It saves the TextGrid file to the same directory as this script
#
# [REQUIREMENTS] 
# You will need to prepare:
# 1) sound files (.wav)
# 2) textgrid files that share the same name with the corresponding sound file (.TextGrid)
# 3) make sure all the sound files,textgrid files and THIS SCRIPT are in the same directory
#
# [INSTRUCTION]
# 1) open the script
# 2) click ok

##### form #####

form don't worry about the content of this box!
	word sound_extension .wav
	word textGrid_extension .textGrid
endform

clearinfo

##### coding starts #####

mySounds = Create Strings as file list... sounds *'sound_extension$'
nSounds = Get number of strings

for iSound to nSounds
	select mySounds
	sound$ = Get string... iSound
	name$ = sound$ - sound_extension$
	textGrid$ = name$ + textGrid_extension$
		
	mySound = Read from file... 'sound$'
	myTextGrid = Read from file... 'textGrid$'
	
	# Change the number to reflect the position you want the tier
	# You can add as many tiers as you like
	# The number indicates the position of the tier (1 is at the top)
	# The word after the number gives the name of the tier
	Insert interval tier... 2 segment
        Insert interval tier... 3 position
        Insert interval tier... 4 word

	select mySound
	plus myTextGrid

	Edit
	
	pause

	endeditor
	
	select myTextGrid
	Write to text file... 'name$'.TextGrid

endfor
