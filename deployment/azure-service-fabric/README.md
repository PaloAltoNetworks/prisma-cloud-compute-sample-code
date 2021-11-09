## Deploy container Defender on [Azure Service Fabric](https://azure.microsoft.com/en-us/services/service-fabric/)
The primary issue is that the container Defender requires Docker to be be running on the host before the service will start.
Service Fabric runs the Docker service without using the standard Windows service mechanism.
Therefore, when the container Defender starts it will fail due to the requirement for the Docker service to be running.

The solution is to pull down `defender.ps1` and remove the requirement.
This script is an example of these steps.
