---
layout: guide
title:  "Transferring bucket from AWS S3 to OCI OS"
categories: guides
updated: 2021-10-20
tags:
- OCI
- AWS
- cloud
---

## How to Move Data from AWS S3 to OCI OS

Goal: Transfer 10+ TB of data from an Amazon Web Services Simple Storage Service bucket to an Oracle Cloud Infrastructure Object Storage bucket

General approach: use rclone to move directly from one endpoint to the other

## Setup

### Setup on OCI

1.  Create the bucket
2.  Generate a secret key (user (top right head looking icon) > user settings > customer secret keys > generate secret key). Save the secret key (will be called `secret_access_key` later), click on the access key name after created and copy the access key name (will be called `access_key_id` later)
3.  Get the namespace: open the cli (top cli icon in web console interface), run `oci os ns get`, copy the result shown with key "data"

### Setup on AWS

1.  Create an instance with FAST data transfer and lots of compute power (I used c5n.18xlarge).
2.  Give that instance an IAM role that has read access to the bucket with the target data.
3.  I used the aws Linux type.
4.  SSH into that instance: `ssh -i <key location> ec2-user@<ip addr>` (note: if you are setting up permissions properly, you will need to be on your corporate network or vpn (if offsite) to access your ec2 instances)
5.  install tmux: `yum install tmux`
6.  install rclone: `yum install rclone`
7.  start tmux (you want things to keep running even if you disconnect)
8.  setup rclone config at `~/.config/rclone/rclone.conf`:

    <!---->

        [aws]
        type = s3
        provider = AWS
        env_auth = true
        region = <aws-region>
        endpoint = 
        acl = private
        server_side_encryption = aws:kms
        sse_kms_key_id = arn:aws:kms:us-east-1:*
        storage_class = INTELLIGENT_TIERING

        [oci]
        type = s3
        provider = Other
        env_auth = false
        access_key_id = <from above>
        secret_access_key = <from above>
        region = <oci region>
        endpoint = https://<oci namespace from above>.compat.objectstorage.<region>.oraclecloud.com

AWS region for me is `us-east-1` OCI region for me is: `us-ashburn-1` you can see what region you are in on the OCI web console top bar and in the AWS web console url.
I don't think that, for aws, acl, server side encryption, kms id, storage class are actually necessary, but whatever.

7.  Test whether it all works: `rclone lsd oci:<bucket name>` and `rclone lsd aws:<bucket name>`
8.  You can test putting things into the oci bucket: `touch test.txt && rclone copy test.txt oci:<bucket name>/test/text.txt` and go take a look at the bucket in the web console

## Upload data

On the aws ec2 vm that you have set up, run `rclone sync aws:<bucket name> oci:<bucket name> --progress --transfers 1000` and now you wait... You could change the number of transfers based on how well things are going. You are in tmux, so you can split: `ctrl-b`+`%` or `ctrl-b`+`"` and then run top or htop in that, look at your cpu usage.

## Clean up

We NEED to clean up a security hole we just made (although not a big one, we already trusted AWS to have our data): go back into the OCI online console and delete the secret key you created.

Also, make sure to shut down the EC2 instance

## Post Mortem - do better next time:

Running on the ec2 shape specified, I am using 100% of the available compute and not saturating the networking (hitting like 250-300 MB/s each way), using about half of the RAM. That could be because I don't have enough cpu power to handle the processing or could be because AWS S3 or OCI OS can't move faster. This can and should be tuned better for more intense transfers as should the number of transfers to do in parallel. Good enough for me though, for 9TB this took 52 minutes...
