This notebook gives a demo how to get SIDFEX position of today and use those positions to generate 10-day trajectories from SITRACK (based on sea ice velocities from NEMO SI3 in 1996-1997)

---

## 1. Get SIDFEX position of today

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

---
## 2. Create netcdf file to initiate the forecast with initial buoys positions 
(from previously created sidfexloc_YYYYMMDD.dat text file)

* Based on Laurent B's tool SItrack and his script `SItrack/tools/generate_idealized_seeding.py`. See my modified script here: `generate_sidfex_seeding.py` [here]().

