Notes on my raytrace programs:

1) This code will only work on machines with IDL 8.0 or higher

2) The directory structure I use to keep things organized is to have the main generic software pieces in one directory, and then include work and
measurement files for an individual event in a file that is labelled in YYYYMMDD format of the first day of the eruption. Most of my code assumes this
structure, so if you would like to organize things differently you will have to edit the code.

3) To run the code in SSW, enter the cme_tracking/YYYYMMDD directory and start sswidl. Then enter run work_YYYYMMDD, 'HH:MM' where 'HH:MM' is the start
time of the measurements. If you just want to begin at the first observation of the event, you can enter '00:00' for the start. If you have a specific
time you'd like to begin, use that. Since my code now begins in COR1, if youw ant to begin in COR2 you will have to manually enter that time.

4) The general functions of the programs are:

The work_YYYYMMDD.pro file in each event subdirectory contains the start and end times for the CME in each field of view (which I determine using
online movies of each event to come up with the times). You want to set the times up to be between two images (i.e. for an event which first appears in 
COR2 at 16:54 UTC, use a start time of 1650.)
 
After the time ranges are established, work_YYYYMMDD will call the work_scloop program. This program searches the data directories for all LASCO and
SECCHI images in the given time ranges, and creates lists of the files. The program only accepts file pairings in STEREO, so if there is a STEREO-B
image for a given time step but no corresponding STEREO-A image, the STEREO-B image will not be used. The code can be modified to use data from only
one STEREO spacecraft. The program will loop through the STEREO image pairs, while also determining the nearest LASCO image (if you have not passed the
end time for C3 data) and passing these images into the work_scraytrace program.

The work_scraytrace program takes the fits files for each observation and creates the image files and headers that will be used in the program. These
images and headers are each stored in pointer arrays to be passed into the rtcloudwidget program, which is the main raytrace driver program. The program
will create both a running difference with a previous image and base difference using the appropriate background, obtained. For different events you may
have to alter the contrast settings, which requires manually editing the code. This is why work_YYYYMMDD.pro has a start variable, so that if you are
multiple images into a measurement and want to alter an image setting, you may do so and resume the code at the appropriate time step.

When you have performed your measurements, you can click the quit button at the bottom of the control widget. This will close program and give you a 
prompt that asks if you'd like to continue to the next time step. Entering y or Y will continue the loop in work_scloop and send the next set of images
into work_scraytrace. Enterng n or N will exit the program (and entering anything else will crash the program). 

5) I have included an example of my work and measurement files in the 20120712 directory. If you use the same format for your measurement data as me,
you can use the read_rt.pro to output the measurements into an IDL structure, which makes performing analysis on the measurements much simpler. 

6) The three .sav files (data_temp.sav, readfittemp.sav, sumtemp.sav) are ASCII templates used to read in files in the program. If you copy my programs
to local directories to use, make sure you include these files.

7) For some reason, at least on SWL03, there is some kind of an issue with the ssw program scc_mkframe. Some times it doesn't compile automatically, but
will do so manually. So if the code ever gives you an error trying to compile scc_mkframe, if you just run .r scc_mkframe and try the code again, 
everything will be fine.

8) I built my code to be able to handle multiple days in HI-1 data, but not COR2. If you are trying to measure an event that is still in the COR2 field
of view over multple days, the easiest way to do it is to create a work_YYYYMMDD file for each day separately. Even then, for the first set of images
after midnight, the code will not work (because of needing the previous day's image for a running difference background). In this case it is probably
easiset to just manually determine the current and previous fits files of the time stamp in question and include those in a manual call to
work_scraytrace.pro

9) If you want to produce an eps figure output of your raytrace mesh on the imagkes, use the /mkim key word. I have also noticed that sometimes, the 
raytrace code does not actually rotate an image so that north points up, but will instead just rotate the mesh to match an upsidedown image. It doesn't
affect the ability to perform a measurement, but it can be confusing if you wish to present you mesh on top of the observations. Using the /flip keyword
will rotate the LASCO image 180 degrees to avoid this. If you wish to create an image of just the observations with no mesh, this can be done by cycling
through the observations, and for all flux rope/shock models included in the raytrace widget going to the cloud tab and selecting the wire off tab and
then hitting quit. Whatever the images are showing in the images when you select quit is what will be saved to the image files. Just make sure you
manually change the name of the files to be saved in work_scraytrace so that your mesh free images do not overwrite your mesh images. You may also want
to change these output images from eps to png for the sake of creating a movie, this can also be done by manually editting the code. All you have to do
is change .eps to .png in the save command in work_scraytrace. 

10) If you have any questions or anything in the code doesn't work properly, email me at hessphil@gmail.com. 
