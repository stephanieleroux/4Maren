This notebook gives a demo how to get SIDFEX position of today and use those positions to generate 10-day trajectories from SITRACK (based on sea ice velocities from NEMO SI3 in 1996-1997)

---

## 1. Get SIDFEX position of today

* Based on the scripts available on SIDFEX website `get_buoy_data-auto_sharing.sh` edited to fit our own purposes (see [get_buoy_data-auto_SLX.sh](https://github.com/stephanieleroux/4Maren/blob/main/NOTEBOOKS/get_buoy_data-auto_SLX.sh) ).
  
* Run as a command with no argument to get buoys of the current day: `./get_buoy_data-auto_SLX.sh`
* Run as `./get_buoy_data-auto_SLX.sh YYYYMMDD` to get buoys for another day.
