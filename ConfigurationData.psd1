@{
    AllNodes = @(
		@{
			NodeName = 'DC1'
			Domain = 'AzureADTest.local'
			Site = 'Site1'
			Functions = @('DomainController','SchemaMaster','DomainNamingMaster','RIDMaster','PDCEmulator','InfrastructureMaster')
			PSDscAllowPlainTextPassword = $true
			},
		@{
			NodeName = 'DC2'
			Domain = 'AzureADTest.local'
			Site = 'Site2'
			Functions = @('DomainController')
			PSDscAllowPlainTextPassword = $true
			},
		@{
			NodeName = 'DC3'
			Domain = 'AzureADTest.local'
			Site = 'Site3'
			Functions = @('DomainController','backup')
			PSDscAllowPlainTextPassword = $true
			},
		@{
			NodeName = 'Server1'
			Domain = 'AzureADTest.local'
			Site = 'Site1'
			Functions = @('MemberServer')
			PSDscAllowPlainTextPassword = $true
			}
    )
	NonNodeData = @{
	Forests = @(
		@{
			ForestName = 'AzureADTest.local'
			Domains = @(
				@{
					DomainName = 'AzureADTest.local'
					PDCEmulator = 'DC1.AzureADTest.local'
					RIDMaster = 'DC1.AzureADTest.local'
					InfrastructureMaster = 'DC1.AzureADTest.local'
				}
			)
			ExternalTimeServers = @('0.north-america.pool.ntp.org','1.north-america.pool.ntp.org')
			FSMORoles = @{
				SchemaMaster = 'DC1.AzureADTest.local'
				DomainnamingMaster = 'DC1.AzureADTest.local'
			}
			ADSites = @(
				@{
					Name = 'Site1'
					Subnets = @('192.168.1.0/24')
				},
				@{
					Name = 'Site2'
					Subnets = @('192.168.2.0/24')
				},
				@{
					Name = 'Site3'
					Subnets = @('192.168.3.0/24')
				}
			)
		}
	)
	}
}
# Save ConfigurationData in a file with .psd1 file extension