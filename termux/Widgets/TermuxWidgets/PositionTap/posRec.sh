
#!/bin/bash

date >> poses
termux-location >> poses
echo "   " `date`
echo "   " `cat poses | grep -c lati`

echo "" >> poses
