#!/bin/bash
cd `pwd`
gcloud compute instances start  --zone "us-central1-c" swift-on-linux  --project "studioso-node-server"
cp -rf ./filter/* ./Sources/filter/
gcloud beta compute scp --scp-flag=-r --zone "us-central1-c" ../filter/* swift-on-linux:~/filter --project "studioso-node-server"
#gcloud beta compute scp --zone "us-central1-c" swift-on-linux:~/ --project "studioso-node-server"

gcloud beta compute ssh --zone "us-central1-c" "swift-on-linux" --project "studioso-node-server"
