configuration testconfig2 {
	Import-DscResource -modulename PSDesiredStateConfiguration
    node DC1 {
        
        windowsfeature telnetclient {
            Ensure = 'Present'
            Name = 'Telnet-Client'
        }
    } 
}

# 
