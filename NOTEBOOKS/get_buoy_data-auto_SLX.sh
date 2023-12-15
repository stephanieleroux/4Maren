#! /bin/ksh

#set -ax

#############################################################
#                                                           #
#  Script to get data for calculating SIDFEx trajectories   #
#  using AWI's IABP buoy target details file                #
#                                                           #
#  Date specified as command-line argument                  #
#     - format: YYYYMMDD                                    #
#     - default today                                       #
#                                                           #
#  Assumes today's forecast meaning initial buoy details    #
#  needed for yesterday's analysis                          #
#                                                           #
#  Ed Blockley, July 2018                                   #
#  Edited by Stephanie Leroux 2023
#
#############################################################

usage () 
{
cat << EOC
 **ERROR** Date format should be YYYYMMDD 
   Usage: ${0##*/} YYYYMMDD
EOC
exit 1
}

# take date from command-line arguments with default today
todayDate=$( date +%Y%m%d )
runDate=${1:-${todayDate}}

# check date format
[[ ${runDate} = [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]] || usage

# define analysis date used for buoys as 1 day ago
#analDate=$( date +%Y%m%d --date="${runDate} 1 day ago" )
#analDate=20231129
# SLX get today and not one day before today as they did
analDate=$( date +%Y%m%d  )

# define/set up working directories 
SIDFEx=/home/lerouste/
scriptDIR=${SIDFEx}
tmpDIR=/home/lerouste/TMP
WDIR=${tmpDIR}/working_${runDate}${pastDStr}
buoyDIR=${WDIR}/buoy_data
outputfile=sidfexloc
mkdir -p ${WDIR} ${buoyDIR}

# SLX
# erase file if already exist
if [ -f "${buoyDIR}/${outputfile}_${analDate}.dat" ]; then
rm -f "${buoyDIR}/${outputfile}_${analDate}.dat"
fi
# create empty one
touch "${buoyDIR}/${outputfile}_${analDate}.dat"

############################################
# create buoy list from AWI file
#
buoyList=${buoyDIR}/buoy_list.txt
cd ${buoyDIR}
echo -e "\nDownloading buoy target details from AWI website...\n"
wget https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx_index/SIDFEx_targettable.txt
cat SIDFEx_targettable.txt | grep "^[0-9]" > ${buoyList}_tmp
[[ -f ${buoyList} ]] && rm ${buoyList}

# loop over buoy lines and decide if valid
while read line; do
   # extract buoy details from line
   buoyID=$( echo ${line} | cut -d " " -f 1 )
   buoyStartYEAR=$( echo ${line} | cut -d " " -f 9 )
   buoyStartDAY=$( echo ${line} | cut -d " " -f 10 )
   buoyEndYEAR=$( echo ${line} | cut -d " " -f 11 )
   buoyEndDAY=$( echo ${line} | cut -d " " -f 12 )

   # convert day of year to real buoy start and end dates
   # (NB. the division by 1 with "bc" is the same as a "floor" operation)
   buoyStart=$( date --date="${buoyStartYEAR}-01-01 +$(echo ${buoyStartDAY}/1 | bc) days" +"%Y%m%d" )
   if [[ ${buoyEndYEAR} != "NaN" && ${buoyEndDAY} != "NaN" ]] ; then
      buoyEnd=$( date --date="${buoyEndYEAR}-01-01 +$(echo ${buoyEndDAY}/1 | bc) days" +"%Y%m%d" )
   else
      # dummy future date
      buoyEnd=21000101
   fi  

   # if the buoy is valid for our current date then write to the buoy list
   if [[ ${analDate} -ge ${buoyStart} ]] && [[ ${analDate} -le ${buoyEnd} ]] ; then
      echo ${buoyID} >> ${buoyList}
   fi  

done < ${buoyList}_tmp
rm ${buoyList}_tmp

############################################
# get buoy data
#
echo -e "\nDownloading buoy details from IABP website...\n"

# loop over buoys from file list
numBuoys=0
while read buoyID; do 

   # get data from IABP
   wget http://iabp.apl.washington.edu/WebData/${buoyID}.dat

   # strip off top line
   sed 1d ${buoyID}.dat > tmpFile.txt
   mv tmpFile.txt ${buoyID}.dat

   # extract relevant date and find closest report to 0Z for lat/lon positions
   # save to ascii file 
   python ${scriptDIR}/derive_buoy_lat-lon_v1.py ${buoyID} ${analDate} > ${buoyID}_${analDate}.dat

   # count number of succesful buoy (non-zero) files and remove zero files that have failed 
   if [[ -s ${buoyID}_${analDate}.dat ]] ; then
      let numBuoys=${numBuoys}+1
      # SLX print in a single file all the successful active buoys with their ID 
      read -r longitude latitude < "${buoyID}_${analDate}.dat"
      echo -e "${buoyID} $longitude $latitude" >> "${buoyDIR}/${outputfile}_${analDate}.dat"

else
      rm ${buoyID}_${analDate}.dat
   fi



done < ${buoyList} # read central buoy list

# complain if no valid buoy files counted for today
if [[ ${numBuoys} -eq 0 ]] ; then

   echo "**ERROR** no buoys found for this date"

   # if today's date (likely crontab initiated) then send an email warning
   if [[ ${runDate} == ${todayDate} ]] ; then

      # define email details
      subject="SIDFEx WARNING : 0 buoys for ${analDate}"
      EMAIL_ID="YOUREMAIL"
      textfile="${buoyDIR}/email_warning.txt"
      cat << EOC > ${textfile}
Hi,
Your SIDFEx job could not find any buoys with reports for yesterday's analysis day ${analDate}
Best

EOC

      # send the email
      echo "Sending warning email to ${EMAIL_ID}"
      /usr/local/bin/mutt -s "${subject}" -i ${textfile} -x -z -n ${EMAIL_ID} << END || status="failed"
END

   fi # today

   exit 9

fi # no buoys
