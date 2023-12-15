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
