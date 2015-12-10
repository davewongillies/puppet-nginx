define nginx::upstream(
  $ensure = 'present',
  $strategy = '',
  $keepalive = false,
  $check_health = false,
  $check_interval = '3000',
  $check_rise = 2,
  $check_fall = 5,
  $check_timeout = 1000,
  $check_default_down = true,
  $check_type = 'tcp',
  $check_port = '',
  $check_keepalive_requests = 1,
  $check_http_send = '',
  $check_http_expect_alive = '',
) {

  validate_bool($check_health)
  validate_bool($check_default_down)
  validate_re($check_type, ['^tcp$','^http$','^ssl_hello$','^mysql$','^ajp$','^fastcgi$'])

  $target_dir = "/etc/nginx/upstreams.d/${name}"

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
    ensure => $ensure,
  }

  file { $target_dir:
    ensure => $ensure ? {
      'present' => 'directory',
      'absent'  => 'absent',
    },
    purge   => true,
    recurse => true,
    force   => true,
  }

  file { "/etc/nginx/conf.d/upstream_${name}.conf":
    content => template('nginx/upstream.conf.erb'),
    notify  => Exec['reload-nginx'],
  }

}
