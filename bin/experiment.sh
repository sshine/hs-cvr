#!/bin/sh

if [ -z "$CVR_USER" -o -z "$CVR_PASS" ]; then
    echo "Please set CVR_USER and CVR_PASS and re-run."
    exit 1
fi

cvr_req() {
    URL=$1
    QUERY=$2
    curl -v -u "$USER:$PASS" -H "Content-Type: application/json" -XPOST "$URL" -d"$QUERY"
    echo
}

cvr_mapping() {
    URL=$1
    curl -v -u "$USER:$PASS" -H "Content-Type: application/json" -XGET "http://distribution.virk.dk/cvr-permanent"
    echo
}

cvr_req_cvr() {
    CVRNUMMER=$1
    cvr_req "http://distribution.virk.dk/cvr-permanent/virksomhed/_search" \
        "{
             \"query\": {
              \"bool\": {
               \"must\": [
                {
                     \"term\": {
                      \"Vrvirksomhed.cvrNummer\": \"$CVRNUMMER\"
                       }
                    }
                 ]
                  }
               }
         }"
 }

# cvr_req_cvr 41834226
cvr_req_cvr 32345794
# cvr_mapping
