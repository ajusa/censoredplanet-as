#!/bin/sh
awk -F'"' '!a[$4]++{print $4}'
