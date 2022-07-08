sudo -v
echo ''
echo 'Execute in Sudo'

BatteryName="BAT0"
ChargePercentage=$1

OUTPUT=$(ls /sys/class/power_supply)
echo "Battery (BAT* is the battery name) - ${OUTPUT}"
echo ''
echo ''
echo "Checking Device Compatability (if --charge_control_end_threshold-- path is returned device is compatible)"
echo ''
ls /sys/class/power_supply/BAT*/charge_control_end_threshold
echo ''
touch /etc/systemd/system/battery-charge-threshold.service
cat > /etc/systemd/system/battery-charge-threshold.service <<EOF

[Unit]
Description= Set the battery charge Threshold
After=multi-user.target
StartLimitBurst=0


[Service]
Type=oneshot
Restart=on-failure
ExecStart=/bin/bash -c 'echo ${ChargePercentage} > /sys/class/power_supply/${BatteryName}/charge_control_end_threshold'


[Install]
WantedBy=multi-user.target

EOF

systemctl enable battery-charge-threshold.service

systemctl start battery-charge-threshold.service

systemctl daemon-reload

systemctl restart battery-charge-threshold.service

sleep 5

echo ''
echo 'Battery Status'
echo ''
cat /sys/class/power_supply/BAT0/status
