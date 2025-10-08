# Log in using Managed Identity
Write-Output "Logging in using Managed Identity"
Connect-AzAccount -Identity

# Set the context using the Subscription ID
$subscriptionId = ""  # Subscription ID
Set-AzContext -SubscriptionId $subscriptionId

# Resource group and list of VMs to keep running (these will not be stopped)
$resourceGroupName = "Dev-Test-Lab"
# $vmsToKeep = @("QC-vm")  # Define the list of VMs to keep running

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

# Filter out the VMs to keep running
$vmsToStop = $vms | Where-Object { $vmsToKeep -notcontains $_.Name }

# Debugging: Print the list of VMs to stop
Write-Host "VMs to stop (not in the keep list): "
$vmsToStop | ForEach-Object { Write-Host $_.Name }

# Stop the VMs that are not in the keep list
foreach ($vm in $vmsToStop) {
    # Get the VM power state
    $vmStatus = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vm.Name -Status
    $powerState = ($vmStatus.Statuses | Where-Object { $_.Code -match 'PowerState' }).Code

    Write-Host "Status of VM $($vm.Name): $powerState"

    # Only stop the VM if it is currently running
    if ($powerState -eq "PowerState/running") {
        Write-Host "Stopping VM: $($vm.Name)"
        Stop-AzVM -ResourceGroupName $resourceGroupName -Name $vm.Name -Force
    } else {
        Write-Host "VM $($vm.Name) is already stopped."
    }
}

Write-Host "Script completed."
