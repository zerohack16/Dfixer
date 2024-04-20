#!/bin/bash
echo "Downloading main script:"
wget https://raw.githubusercontent.com/zerohack16/Dfixer/blob/main/fixer.sh


echo "moving script to right path: "
mv fixer.sh /root/

echo "setting up permissions"
chmod +x /root/fixer.sh

/root/zerodassl.sh
rm /root/fixer.sh

echo "process done."
