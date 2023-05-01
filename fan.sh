echo "Starting ILo4 Silence the Fans"
echo "------------------------------"
echo "ILO4 Address:  $ILO_IP"
echo "ILO Username:  $ILO_USER"
echo "ILO Password:  $ILO_PASS"
echo "Control Delay: $ILO_DELAY"
echo "------------------------------"

# Send a Command via sshpass to ILo4
ilo4_command () {
    sshpass -p $ILO_PASS ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 -oHostKeyAlgorithms=+ssh-dss $ILO_USER@$ILO_IP $1
}

# Read Temperatur form a Sensor and return the actual value
ilo4_getTemp () {
    ret=$(ilo4_command "show /system1/$1" | grep "CurrentReading")
    temp=${ret##*=}
    echo $temp
}

# Set CPU1 Fans Speed
ilo4_setCPU1Fan() {
ilo4_command "fan p 3 max $1"
ilo4_command "fan p 4 max $1"
ilo4_command "fan p 5 max $1"
}

# Set CPU2 Fans Speed
ilo4_setCPU2Fan() {
    ilo4_command "fan p 0 max $1"
    ilo4_command "fan p 1 max $1"
    ilo4_command "fan p 2 max $1"
}

#Set RAID Fan Speed
ilo4_setRAIDFan() {
    ilo4_command "fan p 5 max $1"
}

while true; do
    
    echo "Getting temperature readings..."
    T1=$(ilo4_getTemp sensor2)
    T2=$(ilo4_getTemp sensor3)
    RAID=$(ilo4_getTemp sensor30)
    echo "Done"

    if [[ $T2 > 67 ]] 
    then
        ilo4_setCPU2Fan 255
    elif [[ $T2 > 58 ]] 
    then
        ilo4_setCPU2Fan 39
    elif [[ $T2 > 54 ]] 
    then
        ilo4_setCPU2Fan 38
    elif [[ $T2 > 52 ]] 
    then
        ilo4_setCPU2Fan 34
    elif [[ $T2 > 50 ]] 
    then
        ilo4_setCPU2Fan 32
    else 
        ilo4_setCPU2Fan 30
    fi

    if [[ $T1 > 67 ]] 
    then
        ilo4_setCPU1Fan 255
    elif [[ $T1 > 58 ]] 
    then
        ilo4_setCPU1Fan 39
    elif [[ $T1 > 54 ]] 
    then
        ilo4_setCPU1Fan 38
    elif [[ $T1 > 52 ]] 
    then
        ilo4_setCPU1Fan 34
    elif [[ $T1 > 50 ]] 
    then
        ilo4_setCPU1Fan 32
    else 
        ilo4_setCPU1Fan 30
    fi

    if [[ $RAID > 97 ]] 
    then
        ilo4_setRAIDFan 255
    elif [[ $RAID > 85 ]] 
    then
        ilo4_setRAIDFan 90
    elif [[ $RAID > 80 ]] 
    then
        ilo4_setRAIDFan 85
    elif [[ $RAID > 75 ]] 
    then
        ilo4_setRAIDFan 70
    elif [[ $RAID > 65 ]] 
    then
        ilo4_setRAIDFan 55
    else 
        echo ""
    fi

    echo "CPU 1 Temperature: $T1"
    echo "CPU 2 Temperature: $T2"
    echo "RAID Temperature: $RAID"
    echo ""
    echo "Sleep for $ILO_DELAY seconds.."
    sleep $ILO_DELAY
done