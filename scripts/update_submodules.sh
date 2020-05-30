#!/bin/bash

echo "Pulling cloud services..."
cd ..
git submodule foreach git pull origin master
