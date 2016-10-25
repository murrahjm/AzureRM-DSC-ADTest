@{
    AllNodes = @(
		@{
			NodeName = 'DC1.testdomain.local'
			Domain = 'testdomain.local'
			Site = 'Site1'
			Functions = @('DomainController','SchemaMaster','DomainNamingMaster','RIDMaster','PDCEmulator','InfrastructureMaster')
			},
		@{
			NodeName = 'DC2.testdomain.local'
			Domain = 'testdomain.local'
			Site = 'Site2'
			Functions = @('DomainController')
			},
		@{
			NodeName = 'DC3.testdomain.local'
			Domain = 'testdomain.local'
			Site = 'Site3'
			Functions = @('DomainController','backup')
			},
		@{
			NodeName = 'Server1.testdomain.local'
			Domain = 'testdomain.local'
			Site = 'Site1'
			Functions = @('MemberServer')
			}
    );
	NonNodeData = @{
	Forests = @(
		@{
			ForestName = 'testdomain.local'
			Domains = @(
				@{
					DomainName = 'testdomain.local'
					PDCEmulator = 'DC1.testdomain.local'
					RIDMaster = 'DC1.testdomain.local'
					InfrastructureMaster = 'DC1.testdomain.local'
				}
			)
			ExternalTimeServers = @('0.north-america.pool.ntp.org','1.north-america.pool.ntp.org')
			FSMORoles = @{
				SchemaMaster = 'DC1.testdomain.local'
				DomainnamingMaster = 'DC1.testdomain.local'
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