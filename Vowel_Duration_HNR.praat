# This script is modified from Sam Kirkham's formantExtract script by Aixin Yuan 
# updated in 2023-06-05
# 
# [WHAT DOES IT EXTRACT]
# This script will loop through all the files in a folder, and will extract:
# 1) duration
# 2) mean HNR of 10 sub-intervals which are divided by the 11 time points of the vowel intervals
# from intervals that contain u, i, y in the labels.
#
# [OUTPUT]
# It will save results to a .CSV file in the same directory as this script. 
#
# [REQUIREMENTS] 
# You will need to prepare:
# 1) sound files (.wav)
# 2) textgrid files that shares the same name with the corresponding sound file (.TextGrid)
# 3) make sure all the sound files and textgrid files are in the same directory
#
# [INSTRUCTION]
# 1) open the script
# 2) copy and paste the directory path
# 3) modify the tier info: number/name of tiers, you can edit them in the form, but also remember to
# edit the code in the loops below.
# 4) modify pitch parameters
# 5) click ok

##### form #####

form Information
	comment Directory path of input WAV/PitchTier/TextGrid files:
	text directory C:\Users\...
	comment Enter number of tier which contains vowel duration and HNR info
	natural segment_tier 2
	comment Output file name will be saved in the same directory as this script
	text filename speaker01_vowelhnr.csv
	comment Pitch analysis parameters
	integer pitchFloor 75
	integer pitchCeiling 600
endform

##### coding starts #####

# define output file and heandings
fileappend "'filename$'" Vowel,VowelDuration,HNR1,HNR2,HNR3,HNR4,HNR5,HNR6,HNR7,HNR8,HNR9,HNR10,'newline$'

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
	# query the TextGrid to get find out how many intervals there are in the target tier (segment_tier),
	# storing that number in a variable called "number_of_intervals". Set up a for loop that will be used
	# to go through each of the non-null intervals and meature them. 
	select TextGrid 'file_name$'
	number_of_intervals = Get number of intervals... segment_tier
	for b from 1 to number_of_intervals
		select TextGrid 'file_name$'
		interval_label$ = Get label of interval... segment_tier 'b'
		
		# go through no.3 6 9 12 15 18 intervals only
		if index(interval_label$, "i") <> 0 or
		... index(interval_label$, "u") <> 0 or
		... index(interval_label$, "y") <> 0

			# get tier information
			segment$ = Get label of interval... segment_tier 'b'
		
			# define measure points and get duration
			start = Get starting point... segment_tier 'b'
			end = Get end point... segment_tier 'b'
			duration = end - start
			time0 = start
			time10 = start + (duration * 0.10)
			time20 = start + (duration * 0.20)
			time30 = start + (duration * 0.30)
			time40 = start + (duration * 0.40)
			time50 = start + (duration * 0.50)
			time60 = start + (duration * 0.60)
			time70 = start + (duration * 0.70)
			time80 = start + (duration * 0.80)
			time90 = start + (duration * 0.90)
			time100 = end

			# get HNR of equally divided ###INTERVALS###
			select Sound 'file_name$'
			To Harmonicity (cc)... 0.005 75 0.1 4.5
			hnr1 = Get mean... time0 time10
			hnr2 = Get mean... time10 time20
			hnr3 = Get mean... time20 time30
			hnr4 = Get mean... time30 time40
			hnr5 = Get mean... time40 time50
			hnr6 = Get mean... time50 time60
			hnr7 = Get mean... time60 time70
			hnr8 = Get mean... time70 time80
			hnr9 = Get mean... time80 time90
			hnr10 = Get mean... time90 time100

			# fix decimals
			hnr1$ = fixed$(hnr1, 3)
			hnr2$ = fixed$(hnr2, 3)
			hnr3$ = fixed$(hnr3, 3)
			hnr4$ = fixed$(hnr4, 3)
			hnr5$ = fixed$(hnr5, 3)
			hnr6$ = fixed$(hnr6, 3)
			hnr7$ = fixed$(hnr7, 3)
			hnr8$ = fixed$(hnr8, 3)
			hnr9$ = fixed$(hnr9, 3)
			hnr10$ = fixed$(hnr10, 3)
			duration$ = fixed$(duration, 3)

			# write file
			fileappend "'filename$'" 'segment$','duration$','hnr1$','hnr2$','hnr3$','hnr4$','hnr5$','hnr6$','hnr7$','hnr8$','hnr9$','hnr10$', 'newline$'
		endif
		# close non-null interval if
	endfor
	# close interval loop
endfor
# close file loop

select all
Remove
clearinfo
print All done!
