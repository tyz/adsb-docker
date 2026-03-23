#!/bin/sh

AIRCRAFT_DB=/data/aircraft.csv.gz
UPINTHEAIR=/data/upintheair.json

if [ "${ENABLE_BIAS_T}" = "true" ]; then
    echo "Activating Bias-T for active antenna..."
    /usr/local/bin/rtl_biast -b 1
    sleep 2
    echo
fi

if [ "${HEYWHATSTHAT_ID}" -a ! -f ${UPINTHEAIR} ]; then
    echo "Creating upintheair.json for altitudes ${HEYWHATSTHAT_ID_ALTS-30000}"
    curl -sLo ${UPINTHEAIR} "http://www.heywhatsthat.com/api/upintheair.json?id=${HEYWHATSTHAT_ID}&refraction=0.25&alts=${HEYWHATSTHAT_ID_ALTS-30000}"
    echo
fi

if [ ! -f ${AIRCRAFT_DB} ]; then
    echo "Downloading aircraft database"
    curl -Lo ${AIRCRAFT_DB} https://github.com/wiedehopf/tar1090-db/raw/csv/aircraft.csv.gz
    ls -lh ${AIRCRAFT_DB}
    echo
fi

echo "Starting readsb..."
exec /app/readsb "$@"
