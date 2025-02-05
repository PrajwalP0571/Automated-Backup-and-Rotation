# Automated-Backup-and-Rotation

Project Overview:

This project automates the backup of a project directory on an AWS EC2 instance. The backup is zipped, uploaded to Google Drive using Rclone, and a webhook notification is sent to confirm the backup. The entire process is automated using a Bash script and scheduled via Crontab.

Project Objectives:

Automate Backups: Automatically create and upload backups to Google Drive at scheduled intervals.

Ensure Reliability: Maintain a backup log for tracking and debugging.

Real-Time Notifications: Use webhooks to receive backup confirmation.

Optimize Storage: Implement a structured backup organization and clean-up mechanism.

Technologies Used:

AWS EC2 Instance (Ubuntu)

Bash Scripting (Automating the backup process)

Rclone (Uploading files to Google Drive)

Crontab (Scheduling the script execution)

Webhook.site (Receiving notifications)

Step-by-Step Implementation:

Step 1: Setup the Project Directory on EC2
# $ssh -i /path/to/key.pem ubuntu@<your-ec2-public-ip>

1: Connect to EC2 Instance:

# ssh -i /path/to/key.pem ubuntu@<your-ec2-public-ip>

2: Create a Project Directory:

# $ mkdir -p ~/my_project
# $ echo "<h1>Backup Automation</h1>" > ~/my_project/index.html

Step 2: Install and Configure Rclone

1: Install Rclone:
# $ sudo snap install rclone

2: Configure Google Drive Remote:

# $ rclone config

Create a new remote (gdrive).

Authenticate via a machine with a browser.

Step 3: Write the Backup Script

Create a new script file:

# $ nano ~/backup_script.sh

Paste the following script:

# !/bin/bash

# Variables
PROJECT_FOLDER="/home/ubuntu/my_project"
BACKUP_FOLDER="$HOME/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="backup_$DATE.zip"
BACKUP_DIR="$BACKUP_FOLDER/$DATE"
GDRIVE_REMOTE="gdrive"
BACKUP_LOG="$BACKUP_FOLDER/backup_log.txt"
CURL_URL="https://webhook.site/5047697d-1912-4186-b18c-7ebdd3879adc"

# Step 1: Create a zip of the project folder
echo "Creating zip backup of project folder..."
mkdir -p $BACKUP_DIR
zip -r "$BACKUP_DIR/$BACKUP_NAME" $PROJECT_FOLDER

# Step 2: Upload to Google Drive
echo "Uploading backup to Google Drive..."
rclone copy "$BACKUP_DIR/$BACKUP_NAME" "$GDRIVE_REMOTE:/backups/$DATE" --progress

# Step 3: Log backup details
echo "Backup created at: $DATE" >> $BACKUP_LOG
echo "Backup file: $BACKUP_NAME" >> $BACKUP_LOG
echo "Backup uploaded to Google Drive." >> $BACKUP_LOG

# Step 4: Send cURL request on successful backup (optional)
curl -X POST -H "Content-Type: application/json" -d '{"project": "YourProjectName", "date": "'$DATE'", "test": "BackupSuccessful"}' $CURL_URL

Save and exit using CTRL+X, then Y, then ENTER.

Make the script executable:

# $ chmod +x ~/backup_script.sh

Step 4: Test the Backup Script

Run the script manually:

# $ ./backup_script.sh

Check the backup log:

# $ cat ~/backups/backup_log.txt

Verify the backup on Google Drive using Rclone:

# $ rclone ls gdrive:/backups/

Check webhook notifications:

Open the provided webhook URL in your browser.

Step 5: Automate with Crontab

Open the crontab editor:

# $ crontab -e

Add the following line to schedule backups every 6 hours:

# $ 0 */6 * * * /home/ubuntu/backup_script.sh

Save and exit.

Step 6: Upload the Project to GitHub

Install Git (if not installed):

# $ sudo apt install git -y

Initialize a Git Repository:

# $ cd ~
# $ git init
# $ git add backup_script.sh
# $ git commit -m "Initial commit of backup script"

Push to GitHub:

# $ git remote add origin https://github.com/PrajwalP0571/Automated-Backup-and-Rotation.git
# $ git branch -M main
# $ git push -u origin main

Conclusion:

This project successfully implements an automated backup solution for an EC2-hosted project. It ensures:
✅ Secure storage on Google Drive✅ Scheduled execution via Crontab✅ Real-time webhook notifications✅ Easy restoration and version tracking via GitHub

This approach is scalable and can be enhanced with additional features like encryption, backup retention policies, and monitoring dashboards.

Future Enhancements:

Implement a rotation strategy to delete old backups.

Encrypt backups before uploading to Google Drive.

Add monitoring using AWS CloudWatch.
