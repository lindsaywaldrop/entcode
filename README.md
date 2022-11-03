# entcode on Github

## Introduction

The entcode 3-hair master project is a computational fluid dynamic simulation of odor capture by a chemosensory hair array consisting of three hairs and a supporting, non-chemosensory antenna. The simulations are in two dimensions, representing a cross-section of the array. The project consists of setup for 2,000 individual simulations, each representing a unique combination of the following parameters: 

 * Angle of array to oncoming flow: 0 to 180 degrees
 * Gap-to-hair-diameter ratio of the gaps between chemosensory hairs to their widths: 1 to 50
 * Antenna-to-hair-diameter ratio of the diameter of a chemosensory hair to the diameter of the supporting antenna: 1 to 50
 * Distance of the center hair from the antenna: 0.001 to 0.02 m
 * Reynolds number: 0.1 to 10
 * Odor diffusion coefficient: 1e-9 to 1e-4 m<sup>2</sup> s<sup>-1</sup>
 * Width of the initial odor stripe: 0.5 to 5 % of the domain width
 * Initial odor concentration: 1e3 to 1e7 (no units)
 
The code for this project is based on the code in the publications:

 * L.D. Waldrop, Y. He, S. Khatri. 2018. What can computational modeling tell us about the diversity of odor-capture structures in the Pancrustacea? Journal of Chemical Ecology 44(12): 1084--1100. [Link to journal.](http://em.rdcu.be/wf/click?upn=lMZy1lernSJ7apc5DgYM8Xf93HvoDx-2FwL3RqEtNQvtk-3D_fkB7KMdsFbmRGDUb-2F2KR4sycbwjqUq5ckx7cVvDB-2FT7fLhV2fahT6vPLVjNQAOz2qNtq0mWTUkveTbiL169PUR9BCSzTUd9xLYpR8ot2Stgbk-2F7AgyRdV0OC3JqNZxtjMgPqZR8CtEfIR835i9RgBmTWZZ7OXne4oMsoiKQDo05lf2nRe7DRFKglDDhwrv7ZIrjJcr2opapiPlVCkLIQ1skNDLFmdxg-2FJVTXbMumA9j9-2BO-2FtvJCxPAemaZ9leJstLmImTv8qb9WRutoU8gh6Hw-3D-3D)
 * L.D. Waldrop, L.A. Miller, S. Khatri. 2016. A tale of two antennules: The performance of crab odor-capture organs in air and water. Journal of the Royal Society Interface 13: 20160615. [Link to journal.](http://dx.doi.org/10.1098/rsif.2016.0615)
 
## Reproduction of Project Results

The results to this project was produced on the following platforms: 

 * [IBAMR](https://ibamr.github.io/) v0.10.0 
 * MATLAB release 2019a 
 * R version 4.2.0 
 * Python 3.8.3 
 * VisIt 3.0.2

For specific instructions, please see the project pipeline PDF in the documents folder: (https://github.com/lindsaywaldrop/entcode/blob/master/documents/entcode-Pipeline.pdf)
 
 ## Contacts 
 
 For questions, comments, or concerns, please use Github issues or contact [waldrop@chapman.edu](mailto:waldrop@chapman.edu).
 
 
