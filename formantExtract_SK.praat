# Sam Kirkham 2015: LING416 workshop
# Extracts F1 and F2 from set of labelled vowels (three different time-point options)
# Time point options: (1) 50%; (2) 25% and 50% and 75%
# Assumes a TextGrid with vowel label in second interval on specified tier
# Run from directory where sound files and textgrids are located
# Not compatible with NORM website

form Estimate vowel formants
	word sound_extension .wav
	word textGrid_extension .textGrid
	comment The output file will be created in the same folder as the sound files
	comment Type in name of the output file (if something other then below):
	text filename vowelFormants.csv
	comment Enter number of tier which contains vowel label:
	natural vowel_tier 1
	comment Enter number of tier which contains word label:
	natural word_tier 2
	comment Enter number of tier which contains speaker code:
	natural speaker_tier 3
	comment Please specify the measurement points of the vowel that you wish to analyse:
		choice Time:
			button 50%
			button 25% and 50% and 75%
endform clearinfo

fileappend "'filename$'" Speaker,Vowel,Word,F1_25,F2_25,F3_25,F1_50,F2_50,F3_50,F1_75,F2_75,F3_75,'newline$'

mySounds = Create Strings as file list... sounds *'sound_extension$'
nSounds = Get number of strings

for iSound to nSounds
	select mySounds
	sound$ = Get string... iSound
	
	name$ = sound$ - sound_extension$
	printline 'name$'

	textGrid$ = name$ + textGrid_extension$

	mySound = Read from file... 'sound$'
	myTextGrid = Read from file... 'textGrid$'
	
	select myTextGrid

	# define time point variables
	vowel = Get label of interval... vowel_tier 2
	start = Get starting point... vowel_tier 2
	end = Get end point... vowel_tier 2
	duration = end - start
	midpoint = (start+end)/2
	time25 = start + (duration * 0.25)	
	time75 = start + (duration * 0.75)

	# get coding info (commented out context/speaker for now)
	vowel$ = Get label of interval... vowel_tier 2
	word$ = Get label of interval... word_tier 2
	speaker$ = Get label of interval... speaker_tier 2
	
	# get formants
	select mySound
	To Formant (burg)... 0 5 5500 0.025 30
	# 25% values
	f1_25 = Get value at time... 1 time25 Hertz Linear
	f2_25 = Get value at time... 2 time25 Hertz Linear
	f3_25 = Get value at time... 3 time25 Hertz Linear
	# 50% (midpoint) values
	f1_50 = Get value at time... 1 midpoint Hertz Linear
	f2_50 = Get value at time... 2 midpoint Hertz Linear
	f3_50 = Get value at time... 3 midpoint Hertz Linear
	# 80% (glide) values
	f1_75 = Get value at time... 1 time75 Hertz Linear
	f2_75 = Get value at time... 2 time75 Hertz Linear
	f3_75 = Get value at time... 3 time75 Hertz Linear

	# write file depending on whether user specified inclusion of offglide measurement
	# If they did not specify an offglide measurement write midpoint values only
	if time$ = "50%"
		fileappend "'filename$'" 'speaker$','vowel$','word$',NA,NA,NA,'f1_50','f2_50','f3_50',NA,NA,NA, 'newline$'
	# Otherwise
	elsif time$ = "25% and 50% and 75%"
		fileappend "'filename$'" 'speaker$','vowel$','word$','f1_25','f2_25','f3_25','f1_50','f2_50','f3_50','f1_75','f2_75','f3_75', 'newline$'
	endif
endfor