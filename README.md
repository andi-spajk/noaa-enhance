# NOAA-enhance

Restore and enhance NOAA APT images. Then create band ratio images and run
cloud detection algorithms.

Most files are not black boxes; you should comment in/out lines as you want
depending on the desired tests.

Some scripts will make directories and/or save files. Make sure that you do not
create or rename any folders to identical names. I did not make the scripts very
robust with regards to saving, only displaying.

# Build Requirements
* MATLAB
* Image Processing Toolbox
* Video and Image Blockset

Clone the repo with `git clone git@github.com:andi-spajk/noaa-enhance.git`.

Open the folder in MATLAB.

# Breakdown

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
