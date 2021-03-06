node.default['artifacts']['alfresco']['enabled']        = true
node.default['artifacts']['alfresco-mmt']['enabled']    = true
node.default['artifacts']['sharedclasses']['enabled']   = true
node.default['artifacts']['keystore']['enabled']        = true

root_folder       = node['alfresco']['properties']['dir.root']
shared_folder     = node['alfresco']['shared']
config_folder     = node['tomcat']['config_dir']
base_folder       = node['tomcat']['base']
log_folder        = node['tomcat']['log_dir']

user              = node['tomcat']['user']
group             = node['tomcat']['group']

generate_alfresco_global = node['alfresco']['generate.global.properties']

directory "alfresco-rootdir" do
  path        root_folder
  owner       user
  group       group
  mode        "0775"
  recursive   true
end

directory "alfresco-extension" do
  path        "#{shared_folder}/classes/alfresco/extension"
  owner       user
  group       group
  mode        "0775"
  recursive   true
end

file "alfresco-global-empty" do
  path        "#{shared_folder}/classes/alfresco-global.properties"
  content     ""
  owner       user
  group       group
  mode        "0775"
  only_if     { generate_alfresco_global == true }
end

file_replace_line "#{config_folder}/catalina.properties" do
  replace     "shared.loader="
  with        "shared.loader=${catalina.base}/shared/classes,${catalina.base}/shared/*.jar"
  only_if     { File.exist?("#{config_folder}/catalina.properties") }
end

directory "tomcat-logs-permissions" do
  path        log_folder
  owner       user
  group       group
  mode        "0775"
  recursive   true
end

directory "tomcat-base-permissions" do
  path        base_folder
  owner       user
  group       group
  mode        "0775"
  recursive   true
end
