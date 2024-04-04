# This script is modified from Sam Kirkham's formantExtract script by Aixin Yuan 
# updated in 2024-04-04
# 
# [WHAT DOES IT EXTRACT]
# This script will loop through all the files in a folder, and will extract:
# 1) duration
# 2) Zero-crossing rate of 10 evenly divided chunks
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
# 4) click run to open the form
# 5) modify pitch parameters
# 6) click ok

##### form #####

form Information
	comment Directory path of input WAV/PitchTier/TextGrid files:
	text directory C:\Users\yuana\OneDrive - The University of Auckland\For thesis\1thesis!\
	comment Enter number of tier which contains vowel duration and HNR info
	natural segment_tier 2
	comment Output file name will be saved in the same directory as this script
	text filename speaker01_vowelzcr.csv
   	comment Length of window over which spectrogram is calculated:
   	positive length 0.005
endform

##### coding starts #####

# define output file and heandings
fileappend "'filename$'" Vowel,VowelDuration,zcr1,zcr2,zcr3,zcr4,zcr5,zcr6,zcr7,zcr8,zcr9,zcr10,'newline$'

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

			# chop the interval into small chunks, then extract ZCRs
			select Sound 'file_name$'
			int1 = Extract part... time0 time10 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs1 = Get number of points
			zcr1 = zcs1/length

			select Sound 'file_name$'
			int2 = Extract part... time10 time20 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs2 = Get number of points
			zcr2 = zcs2/length

			select Sound 'file_name$'
			int3 = Extract part... time20 time30 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs3 = Get number of points
			zcr3 = zcs3/length

			select Sound 'file_name$'
			int4 = Extract part... time30 time40 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs4 = Get number of points
			zcr4 = zcs4/length

			select Sound 'file_name$'
			int5 = Extract part... time40 time50 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs5 = Get number of points
			zcr5 = zcs5/length

			select Sound 'file_name$'
			int6 = Extract part... time50 time60 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs6 = Get number of points
			zcr6 = zcs6/length

			select Sound 'file_name$'
			int7 = Extract part... time60 time70 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs7 = Get number of points
			zcr7 = zcs7/length

			select Sound 'file_name$'
			int8 = Extract part... time70 time80 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs8 = Get number of points
			zcr8 = zcs8/length

			select Sound 'file_name$'
			int9 = Extract part... time80 time90 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs9 = Get number of points
			zcr9 = zcs9/length

			select Sound 'file_name$'
			int10 = Extract part... time90 time100 Rectangular 1 0
			To PointProcess (zeroes)... 1 yes no
			zcs10 = Get number of points
			zcr10 = zcs10/length

			# fix decimals
			duration$ = fixed$(duration, 3)
			zcr1$ = fixed$(zcr1, 3)
			zcr2$ = fixed$(zcr2, 3)
			zcr3$ = fixed$(zcr3, 3)
			zcr4$ = fixed$(zcr4, 3)
			zcr5$ = fixed$(zcr5, 3)
			zcr6$ = fixed$(zcr6, 3)
			zcr7$ = fixed$(zcr7, 3)
			zcr8$ = fixed$(zcr8, 3)
			zcr9$ = fixed$(zcr9, 3)
			zcr10$ = fixed$(zcr10, 3)

			# write file
			fileappend "'filename$'" 'segment$','duration$','zcr1$','zcr2$','zcr3$','zcr4$','zcr5$','zcr6$','zcr7$','zcr8$','zcr9$','zcr10$', 'newline$'
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