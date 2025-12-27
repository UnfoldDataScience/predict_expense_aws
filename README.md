# Expense Prediction Application - AWS EC2 Deployment Guide

This guide provides step-by-step instructions to deploy the Expense Prediction Flask application on AWS EC2.

**Quick Start:** Use the provided deployment scripts (`deploy.sh` for Linux/Mac or `deploy.ps1` for Windows) to automatically transfer files while excluding unnecessary folders like `venv`.

## Prerequisites

- AWS Account
- EC2 instance running (Ubuntu/Amazon Linux recommended)
- SSH access to your EC2 instance
- Windows: use WinSCP or PowerShell, Linux/Mac: built-in

## Step 1: Launch EC2 Instance

1. Log in to AWS Console
2. Navigate to EC2 Dashboard
3. Click "Launch Instance"
4. Configure instance:
   - Name: `expense-prediction-app`
   - AMI: Ubuntu Server 22.04 LTS or Amazon Linux 2023
   - Instance type: t2.micro (free tier) or t2.small
   - Key pair: Create new or select existing (download .pem file)
   - Network settings: Allow SSH and HTTP traffic
5. Launch instance and note the Public IP address

## Step 2: Configure Security Group

1. Go to EC2 Dashboard → Security Groups
2. Select your instance's security group
3. Edit Inbound Rules:
   - Ensure: SSH, Port: 22, Source: 0.0.0.0/0 (or your IP for testing)
   - Ensure: Custom TCP, Port: 5000, Source: 0.0.0.0/0 (or your IP for testing)
4. Save rules

## Step 3: Connect to EC2 Instance

### On Windows (PowerShell):
```powershell
ssh -i "path\to\your-key.pem" ubuntu@<EC2-PUBLIC-IP>
```

### On Linux/Mac:
```bash
chmod 400 your-key.pem
ssh -i your-key.pem ubuntu@<EC2-PUBLIC-IP>
```

Replace `<EC2-PUBLIC-IP>` with your instance's public IP address.

## Step 4: Install Dependencies on EC2

Once connected to EC2, run:

```bash
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-venv
sudo apt install python3.12-venv
```

## Step 5: Transfer Files to EC2 Using Deployment Script

The deployment scripts automatically exclude `venv`, `__pycache__`, and other unnecessary files.

**On Windows (PowerShell):**
```powershell
.\deploy.ps1 -KeyFile "path\to\your-key.pem" ubuntu@<EC2-PUBLIC-IP>
```

**On Linux/Mac:**
```bash
chmod +x deploy.sh
./deploy.sh your-key.pem ubuntu@<EC2-PUBLIC-IP>
```

**Note:** Replace `<EC2-PUBLIC-IP>` with your EC2 instance's public IP address.

## Step 6: Setup Application on EC2

SSH back into your EC2 instance and run:

```bash

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

```

## Step 7: Run the Application

```bash
cd ~/expense-prediction
source venv/bin/activate
python3 app.py
```

The application will start on port 5000. You should see output like:
```
 * Running on http://0.0.0.0:5000
```

## Step 8: Access the Application

Open your web browser and navigate to:
```
http://<EC2-PUBLIC-IP>:5000
```

Replace `<EC2-PUBLIC-IP>` with your EC2 instance's public IP address.

## Step 9: Stop the Instance to save extra bill

Once you are done you MUST STOP INSTANCE otherwise you will get billed
Go to Instance list from "instances" -> Check your instance -> From "instance state" dropdown above STOP AND TERMINATE your instance
