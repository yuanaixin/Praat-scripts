# This script is modified from Sam Kirkham's formantExtract script by Aixin Yuan 
# updated in 2023-06-05
# 
# [WHAT DOES IT EXTRACT]
# This script will loop through all the files in a folder, and will extract:
# 1) duration 
# 2) f0 at 11 equally divided points
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
# 2) copy paste the directory path
# 3) modify the tier info: number/name of tiers, you can edit them in the form, but also remember to
# edit the code in the loops below.
# 4) click run to open the form
# 5) modify pitch parameters
# 6) click ok

##### form #####

form Information
	comment Directory path of input WAV/PitchTier/TextGrid files:
	text directory C:\Users\...
	comment Enter number of tier which contains vowel duration and f0 info
	natural segment_tier 2
	comment Output file name will be saved in the same directory as this script
	text filename speaker01_f0.csv
	comment Pitch analysis parameters
	integer pitchFloor 75
	integer pitchCeiling 600
endform

##### coding starts #####

# define output file and heandings
fileappend "'filename$'" Vowel,VowelDuration,Pitch0,Pitch1,Pitch2,Pitch3,Pitch4,Pitch5,Pitch6,Pitch7,Pitch8,Pitch9,Pitch10,'newline$'

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
		
		# go through intervals that only contain i, u, y in their labels
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

			# get f0 of equally divided ###POINTS###
			select Sound 'file_name$'
			To Pitch... 0 pitchFloor pitchCeiling
			pitch0 = Get value at time... time0 Hertz Linear
			pitch1 = Get value at time... time10 Hertz Linear
			pitch2 = Get value at time... time20 Hertz Linear
			pitch3 = Get value at time... time30 Hertz Linear
			pitch4 = Get value at time... time40 Hertz Linear
			pitch5 = Get value at time... time50 Hertz Linear
			pitch6 = Get value at time... time60 Hertz Linear
			pitch7 = Get value at time... time70 Hertz Linear
			pitch8 = Get value at time... time80 Hertz Linear
			pitch9 = Get value at time... time90 Hertz Linear
			pitch10 = Get value at time... time100 Hertz Linear

			# fix decimals
			pitch0$ = fixed$(pitch0, 3)
			pitch1$ = fixed$(pitch1, 3)
			pitch2$ = fixed$(pitch2, 3)
			pitch3$ = fixed$(pitch3, 3)
			pitch4$ = fixed$(pitch4, 3)
			pitch5$ = fixed$(pitch5, 3)
			pitch6$ = fixed$(pitch6, 3)
			pitch7$ = fixed$(pitch7, 3)
			pitch8$ = fixed$(pitch8, 3)
			pitch9$ = fixed$(pitch9, 3)
			pitch10$ = fixed$(pitch10, 3)
			duration$ = fixed$(duration, 3)

			# write file
			fileappend "'filename$'" 'segment$','duration$','pitch0$','pitch1$','pitch2$','pitch3$','pitch4$','pitch5$','pitch6$','pitch7$','pitch8$','pitch9$','pitch10$', 'newline$'
		endif
		# close interval if
	endfor
	# close interval loop
endfor
# close file loop

select all
Remove
clearinfo
print All done!
