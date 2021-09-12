#! bin/bash

print() {
  echo -e "\n\t\t\e[36m----------------- $1 ----------------------\e[0m\n" >>$LOG
  echo -n -e "$1 \t- "
}

status_check() {
  if [ $1 -eq 0 ]; then 
    echo -e "\e[32mSUCCESS\e[0m"
  else 
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi 
}

