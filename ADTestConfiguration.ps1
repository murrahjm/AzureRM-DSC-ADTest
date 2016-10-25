configuration ADTestConfiguration {
Import-DscResource -modulename xPSDesiredStateConfiguration -moduleversion 4.0.0.0
Import-DscResource -modulename xActiveDirectory
    node $allnodes.NodeName {
		$ForestData = $ConfigurationData.NonNodeData.Forests | ?{$_.domains.domainname -eq $Node.Domain}
		$DomainData = $ForestData.Domains | ?{$_.domainname -eq $Node.Domain}

        WindowsFeature IIS {
           Ensure = "Absent"
           Name   = "Web-Server"
        }
        If ($Node.Functions -contains "DomainController"){
            WindowsFeature ADDomainServices {
                Ensure = 'Present'
                Name   = 'AD-Domain-Services'
                IncludeAllSubFeature = $true
            }
        }
		If ($Node.Functions -contains "Backup"){
			WindowsFeature WindowsBackup {
				Ensure = "Present"
				Name   = "Windows-Server-Backup"
				IncludeAllSubFeature = $true
			}
		} else {
			WindowsFeature WindowsBackup {
				Ensure = "Absent"
				Name   = "Windows-Server-Backup"
				IncludeAllSubFeature = $true
			}
		}
			WindowsFeature SNMPService {
				Ensure = 'Absent'
				Name = 'SNMP-Service'
			}
			WindowsFeature SNMPTools {
				Ensure = 'Absent'
				Name = 'RSAT-SNMP'
			}
			If (($Node.domain -eq $ForestData.ForestName) -and ($Node.NodeName -eq $DomainData.PDCEmulator)){
				Registry NTPServers {
					Key = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\W32Time\Parameters'
					ValueName = 'NtpServer'
					ValueType = 'ExpandString'
					ValueData = $($ForestData.ExternalTimeServers -join ' ')
					Ensure = 'Present'
				}
				Registry NTPType {
					Key = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\W32Time\Parameters'
					ValueName = 'Type'
					ValueType = 'ExpandString'
					ValueData = 'NTP'
					Ensure = 'Present'
				}
			} else {
				Registry NTPType {
					Key = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\W32Time\Parameters'
					ValueName = 'Type'
					ValueType = 'ExpandString'
					ValueData = 'NT5DS'
					Ensure = 'Present'
				}
			}
		Registry MaxNegPhaseCorrection {
			Key = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\W32Time\Config'
			ValueName = 'MaxNegPhaseCorrection'
			ValueType = 'Dword'
			ValueData = '172800'
			Ensure = 'Present'
		}
		Registry MaxPosPhaseCorrection {
			Key = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\W32Time\Config'
			ValueName = 'MaxPosPhaseCorrection'
			ValueType = 'Dword'
			ValueData = '172800'
			Ensure = 'Present'
		}
		Registry GarbageCollectionDiagnostics {
			Key='HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NTDS\Diagnostics'
			ValueName= '6 Garbage Collection'
			ValueType = 'Dword'
			ValueData='1'
			Ensure='Present'
		}
		Registry ServerManager{
            Key='HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager'
            ValueName='DoNotOpenServerManagerAtLogon'
            ValueType='Dword'
            ValueData='1'
            Ensure="Present"
        }
		Registry DisableFileAuditing {
			Key='HKEY_LOCAL_MACHINE\SOFTWARE\Dell\ChangeAuditor\Agent'
			ValueName='DisableFileDriver'
			ValueType='Dword'
			ValueData='1'
			Ensure='Present'
		}
    }
}

# 
