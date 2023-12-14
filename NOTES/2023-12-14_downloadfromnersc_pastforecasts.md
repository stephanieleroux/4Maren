## 2023-12-14
My notes on how to download the archives of the past nextsim-f forecasts from NERSC server (for 2019-2023).

---
* Log to Cargo (GRICAD gate for long file transfers).

* Add shortcut for ftp connexion to nersc server:
```
touch ~/.local/share/lftp/bookmarks
echo "ftpnersc               ftp://ftp.nersc.no" >> ~/.local/share/lftp/bookmarks
```
You can now use `ftpnersc` to connect.


 * On GRICAD/DAHU storage space: `/summer/meom/DATA_SET/NEXTSIM-F/` run script to download automatically:

```
#!/bin/bash
for YR in {2019..2022};do

mkdir -p ${YR}
cd ${YR}

for MO in {02..12};do

mkdir -p $MO
cd ${MO}
lftp -e "cd /neXtSIM-F-reforecasts-maren/cmems_mod_arc_phy_anfc_nextsim_hm_202311/${YR}/${MO}/; mget *_hr-nersc-MODEL-nextsimf-ARC-*.nc; bye" ftpnersc

cd ..
done

cd ..
done
```

* I run this script from a screen session so that i can close my terminal and the download continues.
```
screen -S Dnerscsession
./downloadfromnersc.sh
```
Then Ctl+a   + d ('detach').

---
## About the files:
* From Tim W. :
>  the bulletin date is the date the simulation was run (or when it would have been run if it was a reforecast).
the initialisation date is the day before the bulletin date i.e. we have a 1-day hindcast and a 10-day forecast.
when I was doing the reforecasts, I sometimes just did the 1-day hindcast without doing the forecast. For those older dates, I only added the 10-day forecast roughly every 7 days. But for the later dates (in 2023) I ran the forecast everyday, and then there would be 10 files for each date

  

