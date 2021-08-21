# request data
ipmitool -H $IPMIHOST -U $IPMIUSER -P $IPMIPASS -I $IPMIVARIABLE1 $IPMIVARIABLE2 > ipmi_raw

# iterate through sensors
for sens_addr in "${SENSOR_ADDR_LIST[@]}"
do
	line=$(grep $sens_addr ipmi_raw)
	name=$( echo $line | cut -d'|' -f1 )
	status=$( echo $line | cut -d'|' -f 5 | awk '{print $1}' )

	# spoof json file
	echo "{" > ipmi_data
	echo "    \"name\":      \"$name\" ,"      >> ipmi_data
	echo "    \"unique_id\": \"$sens_addr\" ," >> ipmi_data
	echo "    \"state\":     \"$status\" "     >> ipmi_data
	echo "}" >> ipmi_data

	# push data to mosquitto
	mosquitto_pub -h $MOSQUITTOHOST -u $MOSQUITTOUSER -P $MOSQUITTOPASS -t $MOSQUITTOTOPIC/$sens_addr -f ipmi_data
done

