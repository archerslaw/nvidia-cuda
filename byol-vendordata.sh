#!/bin/bash
# BYOLWebSerice Script to cancel subscription with BYOL
#

LOG=/var/log/xxxxx-vendordata.log

### Main

# Check if BYOL or not
curl -s http://169.254.169.254/openstack/latest/meta_data.json | grep '"BYOL": "true"' >> $LOG 2>&1
if [ $? -ne 0 ]; then
	echo "BYOL=true, Cancel subscription and clean repositories, Exit" |tee -a $LOGF
	cat /etc/rehdat-release | grep RedHat >> $LOG 2>&1
	if [ $? -ne 0 ]; then
		rm -fr /etc/yum.repos.d/*.repo
		subscription-manager remove --all
		subscription-manager unregister
		subscription-manager clean
	fi
	cat /etc/SUSE-release | grep SUSE >> $LOG 2>&1
	if [ $? -ne 0 ]; then
		rm -fr /etc/zypp/repos.d/*.repo
		zypper repos -d
	fi
else
	echo "No BYOL, Nothing to do, Exit" |tee -a $LOGF
fi
exit 0
