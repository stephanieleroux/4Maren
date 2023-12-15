This notebook gives a demo how to get SIDFEX position of today and use those positions to generate 10-day trajectories from SITRACK (based on sea ice velocities from NEMO SI3 in 1996-1997)

Last update: 2023-12-15.

---

## STEP 1. Get SIDFEX position of today

* Based on the scripts available on SIDFEX website (`get_buoy_data-auto_sharing.sh`) that i edited to fit our own purposes. See my script here: [get_buoy_data-auto_SLX.sh](https://github.com/stephanieleroux/4Maren/blob/main/NOTEBOOKS/get_buoy_data-auto_SLX.sh) ).
  
* Run as a command with no argument to get buoys of the current day (today): `./get_buoy_data-auto_SLX.sh` . Or run as `./get_buoy_data-auto_SLX.sh YYYYMMDD` to get buoys for another day.

* Once it has run, you will find new files in `./TMP/working_YYYYMMDD/buoy_data/`. The one that you are interested in is `sidfexloc_YYYYMMDD.dat`. It gives ID, longitude, latitude of each buoys we want to consider for that day:
```
vi sidfexloc_20231215.dat
300234065495020 -139.623 75.1796
900120 40.25385 87.15929
900126 -132.4182 75.01255
900128 -40.54528 63.19755
900127 -82.11808 84.46046
300534063809090 12.90818 82.5547
300534062895730 -159.62445 86.37808
300534062025510 -110.25001 86.58769
```

* Important note: The script `get_buoy_data-auto_SLX.sh` does the download of SIDFEX active buoys ID  and then reads the position closest to midnight. This part could be modified according to our needs. __TODO__: check how they do.

* To make it work on a Mac, you need to use gdate instead of date. Install gdate from homebrew (once for all) like this : `>brew install coreutils`. Then in script `get_buoy_data-auto_SLX.sh` above, switch `useonamac` to 1.

## STEP 2. Create netcdf file to initiate the forecast with initial buoys positions 
(from previously created sidfexloc_YYYYMMDD.dat text file)

* Based on Laurent B's tool SItrack and his script `SItrack/tools/generate_idealized_seeding.py` that i edited to fit our own purposes (see my modified script here: `generate_sidfex_seeding.py` [here](https://github.com/stephanieleroux/4Maren/blob/main/NOTEBOOKS/generate_sidfex_seeding.py)).
* Run it from  this little script:
```
#!/bin/bash

# directory where are the demo data if needed.
DATADIR="/Users/leroux/DATA/SASIP/DATA_SItrack/sitrack_demo"

# Link the text file produced at step 1 with buoys ID and positions to the generic name sidfexloc.dat in same directory as the python script.
ln -sf sidfexloc_YYYYMMDD.dat sidfexloc.dat 

python generate_sidfex_seeding.py -d '1996-12-15_00:00:00' --lsidfex 1  -k 0 -S 5 
```
Note that it is the new `--lsidfex  1` option that switches on the sidfex seeding and will require a file name sidfexloc.dat to work. 

Also note that in this example, we give a wrong date to the command (`-d '1996-12-15_00:00:00'`) so that it is possible to advect the buoys from 1997 sea ice velocities in the next step (as an example). In the future we will need to put the current date since we will advect with sea ice forecast.

* Once it has run, a file `sitrack_seeding_sidfex_19961215_00_HSS5.nc` has been produced in `/tools/nc/` that contains the initial location of the SIDFEX buoys, ready to initialize the SITrack advection.

## STEP 3. Run SItrack to advect the buoys from thei initial SIDFEX position based on NEMO demo sea ice velocities
```
#!/bin/bash

DATADIR="/Users/leroux/DATA/SASIP/DATA_SItrack/sitrack_demo"

python si3_part_tracker.py -i ${DATADIR}/NANUK4/NANUK4-BBM23U06_1h_19961215_19970420_icemod.nc \
                    -m ${DATADIR}/NANUK4/mesh_mask_NANUK4_L31_4.2_1stLev.nc \
                    -s ./tools/nc/sitrack_seeding_sidfex_19961215_00_HSS5.nc -e 1996-12-26 -N NANUK4 -F
```
Note that the option `-e 1996-12-26` gives the end date of the trajectories (forecast) to run, here we ask for 10 days.

Note again that since this example uses the 1997 sea ice velocities from Laurent B, we set the buoy dates accordingly so that they artificially fit within the time period.

* Once it has run, it has produced a new netcdf file that contains the trajectories of the buoys (those not falling on the model sea ice have been discared): `./nc/NEMO-SI3_NANUK4_BBM23U06_tracking_sidfex_idlSeed_19961215h00_19961226h00.nc`

## STEP 4. PLOT the trajectories
* Example notebook to plot the trajectories [here](https://github.com/stephanieleroux/4Maren/blob/main/NOTEBOOKS/2023-12-15_demo-SIDFEX-SITRAXCK.ipynb).

---
# Left to do:

* in STEP 1: Look into the code to understand how they select the position at time closest to midnight and make sure we like it this way. If we want to add more criteria of selection, it could also be added here.

* in STEP 3: make sure we could provide some velocity fields that are not from NEMO. Make sure that all variables can be considered  at F-point (i think there is an option but to be checked). How do we provide grid info to the program?

* Make it automatic to run.



