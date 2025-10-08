# Log in using Managed Identity
Write-Output "Logging in using Managed Identity"
Connect-AzAccount -Identity

# Set the context using the Subscription ID
$subscriptionId = "4f3d1918-fd1b-43c1-80c8-8a9d24ee0136"  # Subscription ID
Set-AzContext -SubscriptionId $subscriptionId

# Resource group and list of VMs to keep
$resourceGroupName = "Dev-Test-Lab"
# $vmsToKeep = @("QC-vm")  # Convert to array to properly handle multiple VM names

# Debugging: Display the Azure context and subscription ID
$AzureContext = Get-AzContext
Write-Host "Azure Context: $AzureContext"
Write-Host "Subscription ID: $($AzureContext.Subscription.Id)"

# Get all VMs in the resource group
Write-Host "Getting VMs in the resource group: $resourceGroupName"
$vms = Get-AzVM -ResourceGroupName $resourceGroupName

# Debugging: Print the list of all VMs retrieved
Write-Host "VMs in the resource group: "
$vms | ForEach-Object { Write-Host $_.Name }

# Filter out the VMs to keep
$vmsToStart = $vms | Where-Object { $_.Name -notin $vmsToKeep }

# Debugging: Print the list of VMs to start
Write-Host "VMs to start (not in the keep list): "
$vmsToStart | ForEach-Object { Write-Host $_.Name }

# Start the VMs that are not in the keep list
foreach ($vm in $vmsToStart) {
    # Check the current status of the VM
    $vmStatus = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vm.Name -Status
    Write-Host "Status of VM $($vm.Name): $($vmStatus.Status)"

    # Only start the VM if it is not already running
    if ($vmStatus.Status -ne 'Running') {
        Write-Host "Starting VM: $($vm.Name)"
        Start-AzVM -ResourceGroupName $resourceGroupName -Name $vm.Name
    } else {
        Write-Host "VM $($vm.Name) is already running."
    }
}

Write-Host "Script completed."