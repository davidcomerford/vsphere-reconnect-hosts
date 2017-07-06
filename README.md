# vsphere-reconnect-hosts
 PowerCLI script to reconnect all disconnect ESXi hosts 

 Useful for when a large number of ESXi are in a disconnected state. Particularly after changing the SSL certificate on your vCenter server.

## Requirements
* VMware PowerCLI 5
* Established vCenter session (Connect-VIserver ...)
