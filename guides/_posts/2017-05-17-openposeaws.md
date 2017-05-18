---
layout: guide
title:  "Running OpenPose on AWS"
categories: guides
tags:
- code
- AWS
- ML
- Docker
---

I am doing some work that requires Pose Tracking for my thesis work (as a tool, not a goal). The pose tracking algorithim that I am currently most excited about is the [Part Affinity Field based method](https://arxiv.org/pdf/1611.08050.pdf). I'm looking forward to playing with the new Facbook method too. 

The kind folks at the CMU Perceptual Computing Lab have been kind enough to package their code into a clean library with nice wrappers called [OpenPose](https://github.com/CMU-Perceptual-Computing-Lab/openpose). For now, I wanted to get the demo running in AWS. So I [dockerized it](https://github.com/mjsobrep/openpose/blob/master/Dockerfile) and put it up on [docker hub](https://hub.docker.com/r/mjsobrep/openpose/).

This was my first time using Docker or AWS, so it was a learning experience. Lets go through how you can run their code on AWS using docker to make it easier:

## Setup EC2 Instance
Start of by provisioning an AWS ubuntu deep learning on a p2 instance

Then [SSH](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html) into that machine when it is ready and do this:

- [Install docker](https://docs.docker.com/engine/installation/linux/ubuntu/)
- [Install NVidia Drivers](https://github.com/NVIDIA/nvidia-docker)
  - `wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb`
  -	`sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb`
  - `nvidia-docker run --rm nvidia/cuda nvidia-smi`
- Make a place to store our data: `mkdir data`

## Run

### Docker
`sudo nvidia-docker run -v /home/ubuntu/data:/data -it mjsobrep/openpose:x1 bash`

#### Some helpful hints while you are running in Docker
To leave the docker:
- `Ctrl+p`, `Ctrl+q`
  - Now we have detached from the docker, but it is still running
- Let's see where the docker is running by running: `sudo docker ps`
  - Now we have the container ID
- Let's stop it by running: `sudo docker stop <container id>`

### OpenPose
You should now be in bash inside of the docker container. Lets run some examples:
- Check out what options we have:
  - `./build/examples/openpose/openpose.bin --help`
- Lets make a place for us to put the output:
  - `mkdir ../data/output`
  -	`mkdir ../data/output/poses`
- `./build/examples/openpose/openpose.bin --video examples/media/video.avi --write_video ../data/output/result.avi --write_pose_json ../data/output/poses --no_display`
  - You could pass the `--num_gpu <#>` flag to use more than 1 gpu
  - This will take a while to run (maybe around 1.5 minutes on a p2.xlarge)

Hopefully, you will get a printout along the lines of: 
> Real-time pose estimation demo successfully finished. Total time: 81.456782 seconds.

#### Using your own video
To use your own video, simply put the video in the data folder (`/home/ubuntu/data`) on the EC2 machine and change the `--video` argument to OpenPose

## Getting data off AWS
All of your output will be in the data folder... Now we need to get it back so we can take a look:
Just follow this [guide](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html)

## Stop your EC2
Don't forget to stop the EC2 instance when you are done. Don't want to spend too much money...

## Future Things to Try:
I'm curious to try deployment using some nvidia tools, per this [guide](https://github.com/NVIDIA/nvidia-docker/wiki/Deploy-on-Amazon-EC2)

I could come from a basic ubuntu AMI instead of the learning one and do all of [this]( http://www.cs.stevens.edu/~kbatsos/awscudasetup.html)

I'm also curious whether I could use the EC2 container service with an elastic gpu
