#!/bin/bash
rm app.zip
zip -r app.zip app/
aws s3 cp app.zip s3://nickgeo-dev/
rm vm.zip
zip -r vm.zip vm/
aws s3 cp vm.zip s3://nickgeo-dev/