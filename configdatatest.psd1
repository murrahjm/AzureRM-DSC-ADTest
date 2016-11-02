@{
    AllNodes = @(
		@{
			NodeName = 'DC1'
			Domain = 'testdomain.local'
			Site = 'Site1'
			Functions = @('DomainController','SchemaMaster','DomainNamingMaster','RIDMaster','PDCEmulator','InfrastructureMaster')
			}
    )
}
# Save ConfigurationData in a file with .psd1 file extension