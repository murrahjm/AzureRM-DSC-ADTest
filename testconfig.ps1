configuration testconfig {
	Import-DscResource -modulename PSDesiredStateConfiguration
    node localhost {
        
        windowsfeature telnetclient {
            Ensure = 'Present'
            Name = 'Telnet-Client'
        }
    } 
}

# 
