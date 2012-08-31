#!/bin/bash
# adapted from puppet-nexus module
# author: jburbridge
# since: 6/23/2012

usage() {
cat <<EOF

usage: $0 options

This script will fetch an artifact from a Artifactory

OPTIONS:
   -h    Show this message
   -v    Verbose
   -b    Base URL
   -r	   Repository
   -a    GAV coordinate groupId:artifactId:version
   -c    Artifact Classifier
   -e    Artifact Packaging
   -o    Output file
   -u    Username
   -p	   Password

EOF
}

# Read in Complete Set of Coordinates from the Command Line
BASE_URL=
GROUP_ID=
ARTIFACT_ID=
VERSION=
CLASSIFIER=""
PACKAGING=jar
REPO=
USERNAME=
PASSWORD=
VERBOSE=0

OUTPUT=

while getopts "hva:c:e:o:r:u:p:b:" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         a)
    	     	 OIFS=$IFS
             IFS=":"
		         GAV_COORD=( ${OPTARG/\./\/} )
		           GROUP_ID=${GAV_COORD[0]}
               ARTIFACT_ID=${GAV_COORD[1]}
               VERSION=${GAV_COORD[2]}
		PACKAGING=${GAV_COORD[3]}
	    	     IFS=$OIFS
             ;;
         b)
             BASE_URL=$OPTARG
             ;;
         c)
             CLASSIFIER=$OPTARG
             ;;
#         e)
#             PACKAGING=$OPTARG
#             ;;
         v)
             VERBOSE=1
             ;;
		 o)
			OUTPUT=$OPTARG
			;;
		 r)
		    REPO=$OPTARG
		    ;;
		 u)
		    USERNAME=$OPTARG
		    ;;
		 p)
		    PASSWORD=$OPTARG
		    ;;
     ?)
             echo "Illegal argument $OPTION=$OPTARG" >&2
             usage
             exit
             ;;
     esac
done

if [[ -z $GROUP_ID ]] || [[ -z $ARTIFACT_ID ]] || [[ -z $VERSION ]]
then
     echo "BAD ARGUMENTS: Either groupId, artifactId, or version was not supplied" >&2
     usage
     exit 1
fi

# Define default values for optional components

# If we don't have set a repository and the version requested is a SNAPSHOT use snapshots, otherwise use releases
if [[ "$REPO" == "" ]]
then
	if [[ "$VERSION" == *SNAPSHOT ]]
	then
		REPO="libs-snapshot"
	else
		REPO="libs-release"
	fi
fi
# Construct the base URL
DOWNLOAD_URL="${BASE_URL}/${REPO}/${GROUP_ID}/${ARTIFACT_ID}/${VERSION}/${ARTIFACT_ID}-${VERSION}.${PACKAGING}"

# Authentication
AUTHENTICATION=
if [[ "$USERNAME" != "" ]]  && [[ "$PASSWORD" != "" ]]
then
	AUTHENTICATION="-u $USERNAME:$PASSWORD"
fi

# Output
OUT=
if [[ "$OUTPUT" != "" ]] 
then
	OUT="-o $OUTPUT"
fi

echo "Fetching Artifact from $DOWNLOAD_URL..." >&2
curl -sS -L ${DOWNLOAD_URL} ${OUT} ${AUTHENTICATION} -v  --location-trusted
