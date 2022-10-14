#!/bin/bash

# Created by Jeffrey Maurer on 8/01/22 in the Boss-Scharer lab. Email: jeffrey.maurer@emory.edu
# The purpose of this script is to act as a template for easily running and keeping track of Taiji Pagerank

# There are ~2 required fields to change, the projectDir and the groups.
# The "group" variable are the columns of the manifest file that contains the groups that are compared within each other
# For example, if the manifest column is "cellType" and its values are NK_Cells, Monocytes and CD4, then it will run on those 3 groups

projectDir="/PROJECT/DIR/" # Replace, must end in '/'

# Replace, optional. Do you want an email when this finishes?
email="" # Replace

for group in GROUP1 GROUP2 ... # Replace
do
    # Because of how Taiji does checkpointing, this might be necessary
    mkdir -p ${group}
    cd ${group}

    # Replace with how you want the log to be named
    logname=taiji.${group}.log # Replace, if necessary

    # Used for timing
    start_time=`date +%s`

    echo "Configuring group ${group}" >> ${logname}
    echo "Time: `date`" >> ${logname}

    # The input.yml file needs to be updated; input.${group}.yml
    Rscript ${projectDir}analysis/pagerank/format_taiji.R ${group}
    # The config needs to know which input.yml to use
    python ${projectDir}/analysis/pagerank/make_config.py ${group}

    echo "Running Taiji on group ${group}" >> ${logname}

    taiji run --config config.${group}.yml &>> ${logname}

    end_time=`date +%s`
    total_time=$(( ${end_time} - ${start_time} ))

    echo "Time: `date`" >> ${logname}

    # Replace, if necessary
    outmessage="Script $0 running Taiji on group ${group} has ended its execution in ${total_time} seconds. See the results at: $PWD"

    echo ${outmessage} >> ${logname}

    if [[ ${email} != "" ]]
    then
        mail -s "Script $0 Running Taiji on group ${group} has Finished" ${email} <<< ${outmessage}
    else
        echo ${outmessage}
    fi
    cd ..
done

