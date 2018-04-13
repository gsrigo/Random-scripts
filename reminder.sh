#!/usr/bin/env bash

#This script is to creater reminders.
#add this to your bashrc file with an alias, for example:
#alias reminder="/usr/local/scripts/reminder.sh"


echo "You are about to create a reminder"
read -p "What do you want to be reminded about? " reminder
echo "Cool!, you want to be reminded about $reminder."
echo ""
echo ""
echo "Please input 5pm or 9am for example timez"
echo "Here are some examples:
        10:10am tomorrow
        3pm friday
        22:00 next month
"
read -p "What time do you want to be reminded? " timez
echo ""
echo ""
echo "Okay, I will be reminding you at $timez about $reminder."
echo ""

echo  "export DISPLAY=:0.0 ; zenity --warning --no-wrap --text '$reminder'" | at $timez &> /dev/null
echo "We are done here, bye! "
exit 0
