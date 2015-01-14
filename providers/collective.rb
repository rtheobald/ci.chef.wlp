# Cookbook Name:: wlp
# Attributes:: default
#
# (C) Copyright IBM Corporation 2014.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

def whyrun_supported?
  true
end

action :create do
  resourcesDir = "#{@utils.serverDirectory(new_resource.server_name)}/resources/collective"
  if ::File.exists?(resourcesDir)
    Chef::Log.warn "#{resourcesDir} already exists - nothing to do."
  # TODO: Update the server's attributes so we have a flag to test
  #if @current_resource.isController
  #  Chef::Log.info "#{@new_resource} is already a controller - nothing to do."
  else
    converge_by("Creating collective controller configuration for #{@new_resource}") do
      createController(new_resource)
    end
  end
end

action :join do
  resourcesDir = "#{@utils.serverDirectory(new_resource.server_name)}/resources/collective"
  if ::File.exists?(resourcesDir)
    Chef::Log.warn "#{resourcesDir} already exists - nothing to do."
  # TODO: Update the server's attributes so we have a flag to test
  #if @current_resource.isMember
  #  Chef::Log.info "#{@new_resource} is already a member - nothing to do."
  else
    converge_by("Joining new collective member #{@new_resource}") do
      joinMember(new_resource)
    end
  end
end

action :replicate do
  resourcesDir = "#{@utils.serverDirectory(new_resource.server_name)}/resources/collective"
  if ::File.exists?(resourcesDir)
    Chef::Log.warn "#{resourcesDir} already exists - nothing to do."
  else
    converge_by("Replicating new collective controller configuration for #{@new_resource}") do
      replicateController(new_resource)
    end
  end
end

action :remove do
  if @current_resource.isMember
    Chef::Log.info "#{@new_resource} is already a member - nothing to do."
  else
    converge_by("Removing collective member #{@new_resource}") do
      removeMember(new_resource)
    end
  end
end

def createController(new_resource)
  # TODO: Need to install the collectiveController feature!
  #wlp_install_feature "collectiveController-1.0" do
  #  accept_license true
  #end
  Chef::Log.warn "Params: #{new_resource.server_name} and #{new_resource.keystorePassword}"
  command = "#{@utils.installDirectory}/bin/collective create"
  command << " #{new_resource.server_name}"
  command << " --keystorePassword=#{new_resource.keystorePassword}"
  command << " --createConfigFile=#{@utils.serverDirectory(new_resource.server_name)}/controller.xml"
  execute command do
    command command
    user node[:wlp][:user]
    group node[:wlp][:group]
    returns [0, 22]
  end

  controllerXml = "#{@utils.serverDirectory(new_resource.server_name)}/controller.xml"

  updateAdminUser(controllerXml, new_resource.admin_user, new_resource.admin_password)

end



def joinMember(new_resource)
  Chef::Log.warn "Params: #{new_resource.server_name} and #{new_resource.keystorePassword}"

  ruby_block  "set-env-" do
    block { ENV["JVM_ARGS"] = "-Dcom.ibm.websphere.collective.utility.autoAcceptCertificates=true" }
    not_if { ENV["JVM_ARGS"] == "-Dcom.ibm.websphere.collective.utility.autoAcceptCertificates=true" }
  end

  #@helper.join(new_resource.server_name, new_resource.host, new_resource.port, new_resource.user, new_resource.password, new_resource.keystorePassword)

        #command = "join #{member_name} --host=#{host} --port=#{port} --user=#{user} --password=#{password} --keystorePassword=#{keystorePassword} --createConfigFile"

  command = "#{@utils.installDirectory}/bin/collective join"
  command << " #{new_resource.server_name}"
  command << " --host=#{new_resource.host}"
  command << " --port=#{new_resource.port}"
  command << " --user=#{new_resource.user}"
  command << " --keystorePassword=#{new_resource.keystorePassword}"
  command << " --password=#{new_resource.password}"
  command << " --createConfigFile"
  execute command do
    command command
    user node[:wlp][:user]
    group node[:wlp][:group]
    returns [0, 22]
  end

end

def replicateController(new_resource)

  ruby_block  "set-env-" do
    block { ENV["JVM_ARGS"] = "-Dcom.ibm.websphere.collective.utility.autoAcceptCertificates=true" }
    not_if { ENV["JVM_ARGS"] == "-Dcom.ibm.websphere.collective.utility.autoAcceptCertificates=true" }
  end

  replicaXml = "#{@utils.serverDirectory(new_resource.server_name)}/replica.xml"

  command = "#{@utils.installDirectory}/bin/collective replicate"
  command << " #{new_resource.server_name}"
  command << " --host=#{new_resource.host}"
  command << " --port=#{new_resource.port}"
  command << " --user=#{new_resource.user}"
  command << " --keystorePassword=#{new_resource.keystorePassword}"
  command << " --password=#{new_resource.password}"
  command << " --createConfigFile=#{replicaXml}"
  execute command do
    command command
    user node[:wlp][:user]
    group node[:wlp][:group]
    returns [0, 22]
  end

  updateAdminUser(replicaXml, new_resource.admin_user, new_resource.admin_password)

end

def removeMember(new_resource)
  
end

private

def updateAdminUser(controllerXml, user, password)
  ruby_block "updateAdminUser" do
    block do
      updatedline = "    <quickStartSecurity userName=\"#{user}\" userPassword=\"#{password}\" />"
      file = Chef::Util::FileEdit.new(controllerXml)
      file.search_file_replace_line("quickStartSecurity", updatedline)
      file.write_file
    end
  end
end

def load_current_resource
  @utils = Liberty::Utils.new(node)
end
