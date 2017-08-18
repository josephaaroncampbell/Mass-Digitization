# IMLS-Digitization

## Overview

The Chicago History Museum received federal IMLS funding in 2016 to digitize, provide discovery and access, then store its Nitrate Collection. The digitization covers 35,000 negatives over 70 collections from 8x10 negatives, 6x9, 5x7, 4x5, and down to 35mm roll film. The condition of the negatives ranges from good to extreme curl or degradation.

The whole digitization process starts with the Rights and Reproduction department who pulls, organizes, and provides file naming and metadata for each collection.

From there the negatives are brought to the photography studio for digitization. During which each negative is digitized according to FADGI standards, converted to an 'Archive Master' digital image as well as a Production Master access file.

After digitization, the negatives are taken back to Rights and Reproductions where they may receive more conservation or minor corrections to file naming or organization.

From Rights and Reproductions the negatives then travel the Archivist who works with conservation to pack and store the negatives in specially purchased, explosion proof freezers.

## Repository

This repository contains the workflow documentation for the digitization of the nitrate materials. Its main focus is to house the source code used for the automated production of derivatives. This code is used in [Workflow Part 3: Automated Derivative Output](https://github.com/josephaaroncampbell/Mass-Digitization/wiki/Workflow-Part-3:-Automated-Derivative-Output) to apply relevant, unique tonal adjustments to archival source images in order to output access derivatives. The code applies tonal adjustments based on the mean, max, min, and peak values from a custom histogram for each image. Because of this, each image recieves an individual , more natural, and accurate tonal adjustment. The goal is not to completely replace the user/operator, but rather remove as much of the editing work as possible. 

The code utilized a Windows Batch file to recursively analyze, edit, and output image files using ImageMagick and PowerShell to do the heavy lifting. The future goal for this project is to have a clean, user friendly program built in C++ that is portable to multiple operating systems. 

## Wiki

The wiki of this repository is a close duplicate of the provided workflow. Please refer to the wiki or workflow to determine the proper usage of this automation code.

### Progress:

[X] Research ImageMagick Source    
[X] Create Tone Adjustment Functions    
[X] Create Windows Batch File    
[X] Create Powershell Support Files    
[X] Run Tests and Refine Functions    
[ _IN PROGRESS _] Create Wiki and Workflow Documentation    
[X] Create User Interface    
[ _IN PROGRESS _ ] Convert Batch to C++    
[ ] Convert PowerShell to C++    
[ ] Integrate User Interface with C++    
[ ] Run Tests and Refine Functions    
[ ] Release Alpha    
[ ] Run Tests and Fix Bugs    
[ ] Release Beta    
[ ] Run Tests and Fix Bugs    
[ ] Update Documentation    
[ ] Release Version 1.0    
