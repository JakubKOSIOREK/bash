#!/bin/bash
# script whose task is to query the LDAP database on the SAMBA domain controller
# and save the data in the form of a json file for further data processing

clear

# SETTINGS
jsonName="jsontest.json" # json file name
jsonPath="/mnt" # path to directory with work files
archPath="/mnt" # path to directory with archivum files

# VARIABLES
timestamp=$(date +%Y%m%dT%H%M%S_)
list="$tmp/list.txt"
data="$tmp/data.txt"
json="$jsonPath/$jsonName"
archName="$timestamp$jsonName"
arch="$archPath/$archName"

# READ LDAP BASE
touch $list
samba-tool user list > $list
touch $data
while read -r line ; do
for user in $line ;do
samba-tool user show $user >> $data
done
done < $list

# WRITE DATA TO JSON
touch $json
# add prefix
printf '{\n"users" :\n[\n' > $json
# add converted users data
ed -s $data << 'EOF' >> $json
v/^cn:\|^sn:\|^givenName:\|^whenCreated:\|^displayName:\|^name:\|^badPwdCount:\|^badPasswordTime:\|^lastLogoff:\|^primaryGroupID:\|^accountExpires:\|^sAMAccountName:\|^userPrincipalName:\|^pwdLastSet:\|^userAccountControl:\|^lastLogonTimestamp:\|^whenChanged:\|^lastLogon:\|^logonCount:\|^distinguishedName:/d
,s/^\(.*[^:]*\): \(.*\)/"\1" : "\2"/
g/cn\|sn\|givenName\|whenCreated\|displayName\|name\|badPwdCount\|badPasswordTime\|lastLogoff\|primaryGroupID\|accountExpires\|sAMAccountName\|userPrincipalName\|pwdLastSet\|userAccountControl\|lastLogonTimestamp\|whenChanged\|lastLogon\|logonCount/s/$/,/
,s/^/  /
g/distinguishedName/t. \
s/.*/},/g
1,$-1g/}/t. \
s/.*/{/g
0a
{
.
$s/,//
,p
Q
EOF
# add sufix
printf ']\n}' >> $json
# create archivum file
cp $json $arch

# CLEANER
if [ -f $list ] ; then rm -f $list ; fi
if [ -f $data ] ; then rm -f $data ; fi