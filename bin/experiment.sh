#!/bin/sh

if [ -z "$CVR_USER" -o -z "$CVR_PASS" ]; then
    echo "Please set CVR_USER and CVR_PASS and re-run."
    exit 1
fi

cvr_req() {
    URL="$1"
    QUERY="$2"
    curl -v -u "$CVR_USER:$CVR_PASS" -H "Content-Type: application/json" -XPOST "$URL" -d"$QUERY"
    echo
}

cvr_mapping() {
    URL=$1
    curl -v -u "$CVR_USER:$CVR_PASS" -H "Content-Type: application/json" -XGET "http://distribution.virk.dk/cvr-permanent"
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

# cvr_req_cvr 32345794
# cvr_req_cvr 41834226

cvr_req_name() {
    COMPANY_NAME=$1
    QUERY="{
             \"query\": {
                 \"bool\": {
                     \"minimum_should_match\": 1,
                     \"should\": [
                        {
                            \"match_phrase_prefix\": {
                                \"Vrvirksomhed.virksomhedMetadata.nyesteNavn.navn\": {
                                    \"query\": \"$COMPANY_NAME\",
                                    \"max_expansions\": 100
                                }
                            }
                        }
                    ]
                 }
             }
         }"

    cvr_req "http://distribution.virk.dk/cvr-permanent/virksomhed/_search" "$QUERY"
}

cvr_req_name "Shine"
