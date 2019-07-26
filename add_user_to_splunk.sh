#!/bin/bash
#first line is adding the user permanently to splunk group
#second line is adding the user permanently to wheel group
#in order for the script to work as expected you have to create a cronjob which is executed every minute
/sbin/usermod -aG clientprojectteam <username>
/sbin/usermod -aG wheel <username>

