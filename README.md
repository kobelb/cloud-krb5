/etc/hosts
--------
```
127.0.0.1	kerberos.test.elastic.co
```

/etc/krb5.conf
--------
```
[libdefaults]
	default_realm = TEST.ELASTIC.CO

[realms]
	TEST.ELASTIC.CO = {
		admin_server = kerberos.test.elastic.co
		kdc = kerberos.test.elastic.co
		default_principal_flags = +preauth
	}

[domain_realm]
	localhost = TEST.ELASTIC.CO
```

# ESS Steps
1. `./run.sh` input the ES and Kibana hosts when prompted
2. Upload the resultant `krb-bundle.zip` to as a custom user bundle
3. Deployments -> Select your deployment -> Edit
    1. Elasticsearch user settings overrides

		```
		xpack.security.authc.realms.kerberos.kerb1.keytab.path: es.keytab
		```

    2. Select custom user bundle
    3. Kibana user settings overrides

		```
		xpack.security.authProviders: ['kerberos', 'basic']
		``` 
4. `./map-roles.sh` input the ES host and the password for the `elastic` user

# ECE Steps
1. `./run.sh` input the ES and Kibana hosts when prompted
2. Upload the resultant `krb-bundle.zip` to Google Storage
3. Deployments -> Select your deployment -> Edit -> Use the advanced Elasticsearch configuration
	1. Add the following:
		```
		"elasticsearch": {
			...
			"user_bundles": [
				{
					"name": "krb",
					"url": "https://storage.googleapis.com/kobelb/krb-bundle.zip", 
					"elasticsearch_version": "7.3.0"
				}
			]
		}
		```
	2. Save
4. Edit
	1. Elasticsearch user settings overrides
		```
		xpack.security.authc.realms.kerberos.kerb1.keytab.path: es.keytab
		```
	2. Kibana user settings overrides
		```
		xpack.security.authProviders: ['kerberos', 'basic']
		``` 
5. `./map-roles.sh` input the ES host and the password for the `elastic` user