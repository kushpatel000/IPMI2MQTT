# request data
ipmitool -H $IPMIHOST -U $IPMIUSER -P $IPMIPASS -I $IPMIVARIABLE1 $IPMIVARIABLE2 > $IPMIFILE

# iterate through sensors
for sens_addr in "${SENSOR_ADDR_LIST[@]}"
do
	line=$(grep $sens $IPMIFILE)
	name=$( echo $line | cut -d'|' -f1 )
	status=$( echo $line | cut -d'|' -f 5 | awk '{print $1}' )

	# spoof json file
	echo "{" > $IPMIDATA
	echo "    \"name\":      \"$name\" ,"      >> $IPMIDATA
	echo "    \"unique_id\": \"$sens_addr\" ," >> $IPMIDATA
	echo "    \"state\":     \"$status\" "     >> $IPMIDATA
	echo "}" >> $IPMIDATA

	# push data to mosquitto
	mosquitto_pub -h $MOSQUITTOHOST -u $MOSQUITTOUSER -P $MOSQUITTOPASS -t $MOSQUITTOTOPIC/$sens_addr -f $IPMIDATA
done

