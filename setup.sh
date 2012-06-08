#!/usr/bin/env bash

showoff serve &
sass --scss --watch custom.scss:custom.css &

