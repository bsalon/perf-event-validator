#!/bin/bash

find . -name \*.log | xargs -r rm

exit $?
