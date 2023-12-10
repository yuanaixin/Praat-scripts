# This script is modified from Chad Vicenik's phonation_measurement script (originally based off of a script by Bert Remijsen) by Aixin Yuan 
# Chad's script URL: http://phonetics.linguistics.ucla.edu/facilities/acoustic/PraatVoiceSauceImitator.txt
# updated in 2023-12-11
# 
# This script extracts *UNCORRECTED* H1-H2, H1-A1, H1-A2 and H1-A3 values.
# If you want to extract CORRECTED phonation measurements (H1*-H2*, H1*-A1*, H1*-A2* and H1*-A3*),
# I would suggest using VoiceSauce, which is a MATLAB-implemented program for phonetic analysis.
# Here's the download address: 
# https://phonetics.ucla.edu/voicesauce/index.html
# 
# Here are some tutorials that might help: 
# https://linguistics.ucla.edu/people/keating/ICPhS_PPT_VoiceSauce.pdf
# https://yuanchaiyc.github.io/website/subpages/Tutorial_VS.pdf

# [WHAT DOES IT EXTRACT]
# This script will loop through all the files in a folder, and will extract *UNCORRECTED* H1-H2, H1-A1, H1-A2 and H1-A3 values
# from intervals that contain u, i, y in the labels.
# It makes these measurements at different portions of the interval, based on the 
# amount of chunking specified. To do this, it must measure f0 and the locations of the first three formats.
# If Praat cannot find f0 or all three formants, the file is skipped.
#
# [OUTPUT]
# It will save results to a .txt file in the directory you identified
#
# [REQUIREMENTS] 
# You will need to prepare:
# 1) sound files (.wav)
# 2) textgrid files that share the same name with the corresponding sound file (.TextGrid)
#
# [INSTRUCTION]
# 1) open the script
# 2) copy and paste the directory paths (sound, textgrid, result directories)
# 3) modify the tier info: number/name of tiers, you can edit them in the form, but also remember to
# edit the code in the loops below.
# 4) modify other info, e.g. chunks of each segment, sex, window length, formant references
# 5) click ok

##### form #####

form Calculate F1, F2, and intensity-related measurements for a specific segment
   comment See header of script for details. 

   comment Directory of sound files
   text sound_directory C:\Users\...
   sentence Sound_file_extension .wav
   comment Directory of TextGrid files
   text textGrid_directory C:\Users\...
   sentence TextGrid_file_extension .TextGrid
   comment Full path of the resulting text file:
   text resultfile C:\Users\...

   comment Analyze which tier in the TextGrid:
   integer the_tier 2
   comment Divide segment into how many chunks:
   integer chunk 10
   comment Select sex of speaker:
   choice sex 1
   button male
   button female
   comment Length of window over which spectrogram is calculated:
   positive length 0.005
   comment Settings for Track... algorithm (MALE on the left; FEMALE on the right)
   positive left_F1_reference 500
   positive right_F1_reference 550
   positive left_F2_reference 1485
   positive right_F2_reference 1650
   positive left_F3_reference 2475
   positive right_F3_reference 2750
   positive left_Frequency_cost 1
   positive right_Frequency_cost 1
   positive left_Bandwidth_cost 1
   positive right_Bandwidth_cost 1
   positive left_Transition_cost 1
   positive right_Transition_cost 1
endform

##### coding starts #####

# Here, you list all the sound files in a directory.
# The example gets file names ending with ".wav" from D:\tmp\
Create Strings as file list... list 'sound_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file:
# (edit this if you add or change the analyses!)
titleline$ = "Filename	Segment label	Beginning	End	"
fileappend "'resultfile$'" 'titleline$'
for k from 1 to chunk
	titleline$ = "H1-H2	H1-A1	H1-A2	H1-A3	"
	fileappend "'resultfile$'" 'titleline$'
endfor
titleline$ = "'newline$'"
fileappend "'resultfile$'" 'titleline$'

# Go through all the sound files, one by one:
for ifile to numberOfFiles
	name$ = Get string... ifile
	# A sound file is opened from the listing:
	Read from file... 'sound_directory$''name$'
	soundname$ = selected$ ("Sound", 1)
	sound = selected("Sound")

	# set maximum frequency of Formant calculation algorithm on basis of sex
	# sex is 1 for male (left); sex is 2 for remale (right).
	  if 'sex' = 1
	    maxf = 5000
	    f1ref = left_F1_reference
	    f2ref = left_F2_reference
	    f3ref = left_F3_reference
	    f4ref = 3465
	    f5ref = 4455
	    freqcost = left_Frequency_cost
	    bwcost = left_Bandwidth_cost
	    transcost = left_Transition_cost
	  endif
	  if 'sex' = 2
	    maxf = 5500
	    f1ref = right_F1_reference
	    f2ref = right_F2_reference
	    f3ref = right_F3_reference
	    f4ref = 3850
	    f5ref = 4950
	    freqcost = right_Frequency_cost
	    bwcost = right_Bandwidth_cost
	    transcost = right_Transition_cost
	  endif
	  select 'sound'
	  Resample... 16000 50
	  sound_16khz = selected("Sound")
	  To Formant (burg)... 0.01 5 'maxf' 0.025 50
	  Rename... 'name$'_beforetracking
	  formant_beforetracking = selected("Formant")

	xx = Get minimum number of formants
	if xx > 2
	  Track... 3 'f1ref' 'f2ref' 'f3ref' 'f4ref' 'f5ref' 'freqcost' 'bwcost' 'transcost'
	else
	  Track... 2 'f1ref' 'f2ref' 'f3ref' 'f4ref' 'f5ref' 'freqcost' 'bwcost' 'transcost'
	endif

	  Rename... 'name$'_aftertracking
	  formant_aftertracking = selected("Formant")
	  select 'sound'
	  To Spectrogram... 'length' 4000 0.002 20 Gaussian
	  spectrogram = selected("Spectrogram")
	  select 'sound'
	  To Pitch... 0 60 350
	  pitch = selected("Pitch")
	  Interpolate
	  Rename... 'name$'_interpolated
	  pitch_interpolated = selected("Pitch")

	# Open a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		textgrid = selected("TextGrid")
		select 'textgrid'
		nlabels = Get number of intervals... the_tier
		for label from 1 to nlabels
		   select 'textgrid'
		   labelx$ = Get label of interval... the_tier label

       # go through intervals that contain i, u, y only
       # (edit this if you add or change the analyses!)
		   if index(labelx$, "i") <> 0 or
		   ... index(labelx$, "u") <> 0 or
		   ... index(labelx$, "y") <> 0

		      n_b = Get starting point... the_tier label
		      n_e = Get end point... the_tier label
		      n_d = n_e - n_b
		      n_b$ = fixed$(n_b, 3)
		      n_e$ = fixed$(n_e, 3)

			resultline$ = "'soundname$'	'labelx$'	'n_b$'	'n_e$'	"
			fileappend "'resultfile$'" 'resultline$'

		      for kounter from 1 to 'chunk'

		        n_seg = n_d / chunk
			n_md = n_b + ((kounter - 1) * n_seg) + (n_seg / 2)

			# Get the f1,f2,f3 measurements.
			  select 'formant_aftertracking'
			  f1hzpt = Get value at time... 1 n_md Hertz Linear
			  f2hzpt = Get value at time... 2 n_md Hertz Linear

			if xx > 2
			  f3hzpt = Get value at time... 3 n_md Hertz Linear
			else
			  f3hzpt = 0
			endif

			   select 'sound_16khz'
			   spectrum_begin = n_b + ((kounter - 1) * n_seg)
			   spectrum_end = n_b + (kounter * n_seg)
			   Extract part...  'spectrum_begin' 'spectrum_end' Hanning 1 no
			   Rename... 'name$'_slice
			   sound_16khz_slice = selected("Sound") 
			   To Spectrum (fft)
			   spectrum = selected("Spectrum")
			   To Ltas (1-to-1)
			   ltas = selected("Ltas")

			  select 'pitch_interpolated'
			  n_f0md = Get value at time... 'n_md' Hertz Linear

			if n_f0md <> undefined  

			  p10_nf0md = 'n_f0md' / 10
			  select 'ltas'
			  lowerbh1 = 'n_f0md' - 'p10_nf0md'
			  upperbh1 = 'n_f0md' + 'p10_nf0md'
			  lowerbh2 = ('n_f0md' * 2) - ('p10_nf0md' * 2)
			  upperbh2 = ('n_f0md' * 2) + ('p10_nf0md' * 2)
			  h1db = Get maximum... 'lowerbh1' 'upperbh1' None
			  h1hz = Get frequency of maximum... 'lowerbh1' 'upperbh1' None
			  h2db = Get maximum... 'lowerbh2' 'upperbh2' None
			  h2hz = Get frequency of maximum... 'lowerbh2' 'upperbh2' None
			  rh1hz = round('h1hz')
			  rh2hz = round('h2hz')

			# Get the a1, a2, a3 measurements.

			  p10_f1hzpt = 'f1hzpt' / 10
			  p10_f2hzpt = 'f2hzpt' / 10
			  p10_f3hzpt = 'f3hzpt' / 10
			  lowerba1 = 'f1hzpt' - 'p10_f1hzpt'
			  upperba1 = 'f1hzpt' + 'p10_f1hzpt'
			  lowerba2 = 'f2hzpt' - 'p10_f2hzpt'
			  upperba2 = 'f2hzpt' + 'p10_f2hzpt'
			  lowerba3 = 'f3hzpt' - 'p10_f3hzpt'
			  upperba3 = 'f3hzpt' + 'p10_f3hzpt'
			  a1db = Get maximum... 'lowerba1' 'upperba1' None
			  a1hz = Get frequency of maximum... 'lowerba1' 'upperba1' None
			  a2db = Get maximum... 'lowerba2' 'upperba2' None
			  a2hz = Get frequency of maximum... 'lowerba2' 'upperba2' None
			  a3db = Get maximum... 'lowerba3' 'upperba3' None
			  a3hz = Get frequency of maximum... 'lowerba3' 'upperba3' None

			# Calculate potential voice quality correlates.
			   h1mnh2 = 'h1db' - 'h2db'
			   h1mna1 = 'h1db' - 'a1db'
			   h1mna2 = 'h1db' - 'a2db'
			   h1mna3 = 'h1db' - 'a3db'
			   rh1mnh2 = round('h1mnh2')
			   rh1mna1 = round('h1mna1')
			   rh1mna2 = round('h1mna2')
			   rh1mna3 = round('h1mna3')

			# Fix decimals
			   h1mnh2$ = fixed$(h1mnh2, 3)
			   h1mna1$ = fixed$(h1mna1, 3)
			   h1mna2$ = fixed$(h1mna2, 3)
			   h1mna3$ = fixed$(h1mna3, 3)

			else
				h1mnh2 = 0
				h1mna1 = 0
				h1mna2 = 0
				h1mna3 = 0
			endif


			   resultline$ = "'h1mnh2$'	'h1mna1$'	'h1mna2$'	'h1mna3$'	"
			   fileappend "'resultfile$'" 'resultline$'
			endfor

		    resultline$ = "'newline$'"
		    fileappend "'resultfile$'" 'resultline$'

		   endif
		endfor
	endif
	select all
	minus Strings list
	Remove
	select Strings list
endfor

select all
Remove
