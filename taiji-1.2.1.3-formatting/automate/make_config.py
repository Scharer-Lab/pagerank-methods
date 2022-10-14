# This simple python script takes the config.template.yml file and turns it into the config file used by runTrackAllComps.sh

import os
import sys

variableOfInterest = sys.argv[1]

with open("/home/boss_lab/Apps/bitbucket/pagerank/taiji-1.2.1.3-formatting/automate/config.template.yml", 'r') as f: # TODO: This might change
    text = f.readlines()
    text = [line.format(variableOfInterest) for line in text]
    with open("config." + variableOfInterest + ".yml", 'w') as ff:
        for line in text:
            ff.write(line)
