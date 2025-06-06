# NOAA-enhance

Restore and enhance NOAA APT images. Then create band ratio images and run
cloud detection algorithms.

Most files are not black boxes; you should comment in/out lines as you want
depending on the desired tests.

Some scripts will make directories and/or save files. Make sure that you do not
create or rename any folders to identical names. Out-of-the-box, this repo has
no name collisions. I did not make the scripts robust with regards to saving,
only displaying.

# Build Requirements

* MATLAB
* Image Processing Toolbox
* Computer Vision Toolbox

# Running

Clone the repo with `git clone git@github.com:andi-spajk/noaa-enhance.git`. The
images take up huge storage, so do not be alarmed if it is slow.

Open the folder in MATLAB.

# Breakdown

## Code

* `apt_fft_cropped.m`
    * Compare FFT of image when extreme static noise is uncropped/cropped
* `apt_histeq_fft.m`
    * Examine FFT of image before and after histogram equalization
* `band_ratio.m`
    * Calculate and display band ratio images, both (APT-A / APT-B) and (B / A).
    * Examine their FFTs
* `demo_cloud.m`
    * Run cloud detection on raw, enhanced, and band ratio images 
    * Band ratio is not intended for cloud study, but we did it for fun.
* `demo_restore_enhance_band.m`
    * Perform all the processing that we attempted
    * This file is a black box -- just run it.
* `histeq_med_ratio.m`
    * Perform histogram equalization, median filtering, and band ratio processing in that order
    * Also equalize the band ratio image
* `lpf.m`
    * Attempt to remove periodic noise with many types of low-pass filters and notch filters.
    * All methods failed.
* `masking.m`
    * Attempt to remove periodic noise with masking, averaging, and median'ing.
    * All methods failed.
* `med_and_histeq.m`
    * Perform histogram equalization and median filtering in that order
    * Compare with the reverse order
* `med_ratio_histeq.m`
    * Perform median filtering, band ratio processing, and histogram equalization in that order
    * This was the final order that we settled on for our results.
* `report.m`
    * Create some extra plots to make the report look nicer.

## Directories

* `band_ratio`
    * Outputs of band ratio processing, specifically `med_ratio_histeq.m`
* `enhanced`
    * Histogram equalization and 5x5 median filtering
* `enhanced3x3`
    * Histogram equalization and 3x3 median filtering
* `images`
    * Raw APT-A and APT-B images, sorted by date and labeled by satellite
* `images_all`
    * Raw images, all in one folder. Also outputs of feature detection and cloud
      detection scripts.
* `medians`
    * Various median filter sizes. Also testing order of histeq then median or
      vice versa