class mysql::server {

	package { "mysql-server": ensure => installed }

	service { "mysql":
		enable => true,
		ensure => running,
		require => Package["mysql-server"],
	}

	exec { "set-mysql-password":
		unless => "mysqladmin -uroot -p$mysql_root_password status",
		path => ["/bin", "/usr/bin"],
		command => "mysqladmin -uroot password $mysql_root_password",
		require => Service["mysql"],
	}
}

# @source: http://bitfieldconsulting.com/puppet-and-mysql-create-databases-and-users
define mysqldb( $user, $password ) {
	exec { "create-${name}-db":
		unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
		command => "/usr/bin/mysql -uroot -p$mysql_root_password -e \"create database ${name}; grant all on ${name}.* to ${user}@localhost identified by '$password';\"",
	}
}
