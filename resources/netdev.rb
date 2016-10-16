resource_name :systemd_netdev
provides :systemd_netdev

include SystemdCookbook::Mixin::PropertyHashConversion
include SystemdCookbook::Mixin::DSL

option_properties SystemdCookbook::Netdev::OPTIONS

default_action :create

%w( create delete ).map(&:to_sym).each do |actn|
  action actn do
    conf_d = '/etc/systemd/network'

    directory conf_d do
      not_if { new_resource.action == :delete }
    end

    u = systemd_unit "#{new_resource.name}.netdev" do
      content property_hash(SystemdCookbook::Netdev::OPTIONS)
    end

    file "#{conf_d}/#{u.name}" do
      content u.to_ini
      action new_resource.action
    end
  end
end
