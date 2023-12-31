# This script is modified from Sam Kirkham's formantExtract script by Aixin Yuan 
# updated in 2023-10-23
# 
# [WHAT DOES IT EXTRACT]
# This script will loop through all the files in a folder, and will extract F1/F2/F3 values from timepoints of:
# (1) 50%; (2) 20% and 35% and 50% and 65% and 80%
# from intervals that contain u, i, y in the labels.
#
# [OUTPUT]
# It will save results to a CSV file in the same directory as this script. 
#
# [REQUIREMENTS] 
# You will need to prepare:
# 1) sound files (.wav)
# 2) textgrid files that share the same name with the corresponding sound file (.TextGrid)
# 3) make sure all the sound files and textgrid files are in the same directory
#
# [INSTRUCTION]
# 1) open the script
# 2) copy and paste the directory path
# 3) modify the tier info: number/name of tiers, you can edit them in the form, but also remember to
# edit the code in the loops below.
# 4) click ok

##### form #####

form Enter the relevant info below:
	comment Enter the directory where the WAV/TextGrid files are located:
	sentence directory C:\Users\...
	comment Output file name (ends in .csv): will be saved in same directory as this script
	text filename speaker1_vowels.csv
        comment Enter speaker name or code
	text speaker 1
	word sound_extension .wav
	word textGrid_extension .textGrid
	comment Enter number of tier which contains token label:
	natural token_tier 1
	comment Enter number of tier which contains vowel label:
	natural vowel_tier 2
	comment Enter number of tier which contains label label:
	natural label_tier 3
        comment Enter number of tier which contains word label:
	natural word_tier 4
	comment Please specify the measurement points of the vowel that you wish to analyse:
		choice Time:
			button 50%
			button 20% and 35% and 50% and 65% and 80%
endform clearinfo

##### coding starts #####

# define output file and heandings
fileappend "'filename$'" Speaker,Vowel,Token,Label,Word,f1_20,f2_20,f3_20,f1_35,f2_35,f3_35,f1_50,f2_50,f3_50,f1_65,f2_65,f3_65,f1_80,f2_80,f3_80,'newline$'

# make a list of all the sound files in the directory we're using, and put the number of filenames into the variable
mySounds = Create Strings as file list... list 'directory$'*.wav
nSounds = Get number of strings

# start file loop:
for j from 1 to nSounds
	# query the filelist to get the first filename for it, then read it in
	select Strings list
	current_token$ = Get string... 'j'
	Read from file... 'directory$''current_token$'
	
	# here we make a variable called "file_name$" that will be equal to the filename minus the ".wav" extension:
	file_name$ = selected$ ("Sound")
	
	# now we get the corresponding TextGrid and read it in:
	Read from file... 'directory$''file_name$'.TextGrid
	mySound = Read from file... 'directory$''file_name$'.wav

	# start interval loop:
	# query the TextGrid to get find out how many intervals there are in the target tier (vowel_tier),
	# storing that number in a variable called "number_of_intervals". Set up a for loop that will be used
	# to go through each of the non-null intervals and meature them. 
	select TextGrid 'file_name$'
	number_of_intervals = Get number of intervals... vowel_tier
	for b from 1 to number_of_intervals
		select TextGrid 'file_name$'
		interval_label$ = Get label of interval... vowel_tier 'b'
		
		# go through intervals only
		if index(interval_label$, "i") <> 0 or
		... index(interval_label$, "u") <> 0 or
		... index(interval_label$, "y") <> 0

		# define measure points
		vowel$ = Get label of interval... vowel_tier 'b'
        	token$ = Get label of interval... token_tier 2
		label$ = Get label of interval... label_tier 1
		word$ = Get label of interval... word_tier 1
		start = Get starting point... vowel_tier 'b'
        	end = Get end point... vowel_tier 'b'
        	duration = end - start
        	midpoint = start + (0.50 * duration)
		time20 = start + (duration * 0.20)
        	time35 = start + (duration * 0.35)
        	time50 = start + (duration * 0.50)
        	time65 = start + (duration * 0.65)
		time80 = start + (duration * 0.80)

		#### do vowel analysis here
		select Sound 'file_name$'
        	To Formant (burg)... 0 5 5500 0.025 30
        	selectObject: "Formant " + file_name$
		# 20% values
		f1_20 = Get value at time... 1 time20 Hertz Linear
		f2_20 = Get value at time... 2 time20 Hertz Linear
		f3_20 = Get value at time... 3 time20 Hertz Linear
		# 35% values
		f1_35 = Get value at time... 1 time35 Hertz Linear
		f2_35 = Get value at time... 2 time35 Hertz Linear
		f3_35 = Get value at time... 3 time35 Hertz Linear
		# 50% (midpoint) values
		f1_50 = Get value at time... 1 midpoint Hertz Linear
		f2_50 = Get value at time... 2 midpoint Hertz Linear
		f3_50 = Get value at time... 3 midpoint Hertz Linear
		# 65% values
		f1_65 = Get value at time... 1 time65 Hertz Linear
		f2_65 = Get value at time... 2 time65 Hertz Linear
		f3_65 = Get value at time... 3 time65 Hertz Linear
		# 80% (glide) values
		f1_80 = Get value at time... 1 time80 Hertz Linear
		f2_80 = Get value at time... 2 time80 Hertz Linear
		f3_80 = Get value at time... 3 time80 Hertz Linear

		# write file depending on whether user specified inclusion of offglide measurement
        	# If they did not specify an offglide measurement write midpoint values only
        	if time$ = "50%"
	        	fileappend "'filename$'" 'speaker$','token$','vowel$','label$','word$',NA,NA,NA,NA,NA,NA,'f1_50','f2_50','f3_50',NA,NA,NA,NA,NA,NA, 'newline$'
        	# Otherwise
        	elsif time$ = "20% and 35% and 50% and 65% and 80%"
	         	fileappend "'filename$'" 'speaker$','token$','vowel$','label$','word$','f1_20','f2_20','f3_20','f1_35','f2_35','f3_35','f1_50','f2_50','f3_50','f1_65','f2_65','f3_65','f1_80','f2_80','f3_80', 'newline$'
		endif
        	endif

     	endfor
     	select all
     	minus Strings list
     	Remove
endfor

# And at the end, a little bit of cleanup and a message to let you know that it's all done.
select all
Remove
clearinfo
print Yay all done!
