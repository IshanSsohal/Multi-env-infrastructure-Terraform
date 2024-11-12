         ___        ______     ____ _                 _  ___  
        / \ \      / / ___|   / ___| | ___  _   _  __| |/ _ \ 
       / _ \ \ /\ / /\___ \  | |   | |/ _ \| | | |/ _` | (_) |
      / ___ \ V  V /  ___) | | |___| | (_) | |_| | (_| |\__, |
     /_/   \_\_/\_/  |____/   \____|_|\___/ \__,_|\__,_|  /_/ 
 ----------------------------------------------------------------- 


ACS730_Fall_2024: Assignment 1 Effective use of Terraform to deploy multi-environment infrastructure.


Introduction
The deployment of a scalable and secure AWS infrastructure, separated into two environments—production (prod) and non-production (non-prod), is automated by this Terraform project. The modular infrastructure consists of:

VPCs for Prod and Non-Prod Environments: Prod and non-prod environments have different Virtual Private Clouds (VPCs), each with a unique collection of private and public subnets.

Route tables, NAT gateways (non-production only), and Internet gateways are used in network configuration to control network traffic.

Security Groups: distinct security groups for non-production and production EC2 instances, with access restricted by the least privilege principle; bastion host security group for SSH access.

EC2 instances:

Non-Prod: Contains two web servers on private subnets with Apache web server installed to deliver custom content, as well as a bastion host in the public subnet.
Prod: Contains two private subnet EC2 instances without internet access or additional packages.
VPC Peering: Provides safe access through the bastion host by connecting non-production and production VPCs.

To make managing networking (network), EC2 (webservers), and VPC peering (peering) resources easier, the project makes use of modules. With environments (nonprod, prod, and vpcpeering), deployment takes a modular approach for simpler maintenance, concern separation, and reuse.

In order to guarantee the security and isolation of the production environment, instances in private subnets are securely connected to using the bastion host.


Below is the step by step implementation of this infrastruture.

you have to create keypairs through aws Management console 
names of keypair
1. bastion-kp
2. private-vm-kp

I am stating explicitly i have created two keypairs one to access the bastion vm in public subnet2 of nonprod vpcpeering named- bastion-kp.
2nd keypair named - private-vm-kp to access the vms in all private subnets of non prod and prod vpcs. 

Note: I have created both keypairs through AWS management console.


1. start from Session2/02_task2_completed/Assigment1/nonprod

run terraform init
    terrafrom validate
    terraform plan
    terraform apply
    
2. change directory to Session2/02_task2_completed/Assigment1/prod

run terraform init
    terrafrom validate
    terraform plan
    terraform apply
    
3. change directory to Session2/02_task2_completed/Assigment1/vpcpeering

run terraform init
    terrafrom validate
    terraform plan
    terraform apply
    

once these are done our infrastructure will be created as per the provided diagram.

Now we will access the bastion from our local terminal

as we have created keypairs manually through AWS console

1. Locate Your Key Files: Go to the directory containing your key files (bastion-kp.pem and private-vm-kp.pem) using File Explorer.
   
   Right-Click and Go to Properties:
   Right-click on the key file, and click on Properties.
2. Navigate to Security Tab:
  
   Click on the Security tab.
   Click on Advanced.
3. Disable Inheritance:
   
   Click Disable inheritance.
   Choose Remove all inherited permissions from this object to start from scratch.
4. Add a New Permission:
   
   Click on Add, then Select a principal.
   Type your Windows username, click Check Names, and then OK.
5. Grant Read Permission:
   
   Set the permissions to Read only.
   Click OK to save the changes.

6. Apply Changes:
   Click Apply and then OK to close all dialogs.
   These steps will effectively set the equivalent permissions to chmod 400 for the .pem files in Windows, ensuring they are readable only by the intended user.

Now lets ssh in to bastion and then from bastion to vm1, vm2 in non prod vpc and vm3 and vm4 in prod vpc.

Step 1: SSH into the Bastion Host (Public Subnet of Non-Prod VPC)

cd /path/to/your/keyfiles

for me it was cd users/ishan/Downloads

   this was my path - C:\Users\ishan\Downloads
   
   
 1. Connect to the Bastion Host using the Bastion key pair (bastion-kp.pem). Replace <Bastion_Public_IP> with the actual public IP of the bastion host
 
    ssh -i bastion-kp.pem ec2-user@<Bastion_Public_IP>
 
 2.  Create the private-vm-kp.pem File on the Bastion Host
 
     touch private-vm-kp.pem

3.  Edit the File Using vi

        vi private-vm-kp.pem

4. Enter the insert mode:
Once inside the vi editor, press i to enter insert mode.

5. Paste the private key for private-vm-kp:
Right-click in the terminal or use Shift + Insert to paste the copied private key.

6. Save and exit the vi editor:
Press ESC to exit insert mode.
Type :wq and press Enter to save the changes and quit.


7. Set the Correct File Permissions for the Key

   chmod 400 private-vm-kp.pem

8.  SSH into the Private VM1 -non prod vpc
     
    ssh -i private-vm-kp.pem ec2-user@<Private_VM_IP>

    once we are here we just need to see 
    "systemctl status httpd"
     to see if httpd is running
     
     curl http://<private IP of ec2 instance>

9.  SSH into the Private VM2 -non prod vpc

    ssh -i private-vm-kp.pem ec2-user@<Private_VM_IP>
    
    once we are here we just need to see 
    "systemctl status httpd"
     to see if httpd is running
     
     curl http://<private IP of ec2 instance>

10.  SSH into the Private VM1  prod vpc
     
    ssh -i private-vm-kp.pem ec2-user@<Private_VM_IP>


11.  SSH into the Private VM4  prod vpc

    ssh -i private-vm-kp.pem ec2-user@<Private_VM_IP>



This concludes our assignment.


Thank You!

Ishan Sohal
153362223



