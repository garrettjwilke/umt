#!/usr/bin/env bash

PROJECT_NAME=umt

ARGUMENT=$1
VERSION_NUMBER=$(date +%s | sed 's#.#&.#3' | sed 's#.#&.#7')

name-entry() {
NAME_FULL=$(zenity --entry \
--title="What is the customer's full name?" \
--text="Enter customer's full name:" \
--entry-text "")

if [[ "$?" -gt 0 ]]
then
  echo "exiting"
  exit
fi

if [[ "$NAME_FULL" == "" ]]
then
  echo "no name entered"
  exit
fi

NAME_COUNT=$(echo $NAME_FULL | wc -w)

if [[ "$NAME_COUNT" -gt "1" ]]
then
  NAME_FIRST=$(echo $NAME_FULL | awk '{print $1}')
  NAME_LAST=$(echo $NAME_FULL | sed "s/$NAME_FIRST\ //g")
else
  NAME_FIRST=$NAME_FULL
  NAME_LAST=""
fi
}

help-menu() {
echo "help-menu"
exit
}

test-menu() {
name-entry
echo "First Name: $NAME_FIRST"
echo "Last Name: $NAME_LAST"
exit
}

push-to-git() {
VERSION_NUMBER_OLD=$(cat readme.md | grep "Version Number:" | awk '{print $4}')
sed -i "s/$VERSION_NUMBER_OLD/$VERSION_NUMBER/g" readme.md
git add .
git commit -m "$PROJECT_NAME - $VERSION_NUMBER"
git push
}

case $ARGUMENT in
-h|--help) help-menu;;
-t|--test) test-menu;;
"") echo "blank";;
--git) push-to-git;;
*) echo "bad flag. run with --help"; exit;;
esac
