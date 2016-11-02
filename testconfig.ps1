configuration testconfig {
	Import-DscResource -modulename PSDesiredStateConfiguration
	Import-DscResource -modulename xPSDesiredStateConfiguration -moduleversion 4.0.0.0
	Import-DscResource -modulename xActiveDirectory
    node $allnodes.NodeName {
        
        windowsfeature telnetclient {
            Ensure = 'Present'
            Name = 'Telnet-Client'
        }
        
}

# 
