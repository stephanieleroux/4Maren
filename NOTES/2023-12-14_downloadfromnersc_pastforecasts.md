

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
