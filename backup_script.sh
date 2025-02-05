#!/bin/bash

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

# Step 5: Clean up old backups (you can add a function for the rotation strategy here)
