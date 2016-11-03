configuration testconfig {
	Import-DscResource -modulename PSDesiredStateConfiguration
    node $allnodes.NodeName {
        
        windowsfeature telnetclient {
            Ensure = 'Present'
            Name = 'Telnet-Client'
        }
    } 
}

# 
