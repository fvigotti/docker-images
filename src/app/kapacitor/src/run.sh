#!/usr/bin/env bash
echo -n 'Waiting for InfluxDB API'
while ! (ret=$(curl -I -s "$INFLUXDB_URL/ping" -o /dev/null -w "%{http_code}"); [ $ret -eq 204 ]) do
	echo -n '.'
	sleep 3s
done
echo '\nInfluxDB API Ready'
kapacitord -hostname $HOSTNAME -config /etc/kapacitor/kapacitor.conf