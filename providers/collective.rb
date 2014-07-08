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
  if @current_resource.isController
    Chef::Log.info "#{@new_resource} is already a controller - nothing to do."
  else
    converge_by("Creating collective controller configuration for #{@new_resource}") do
      createController(new_resource)
    end
  end
end

action :join do
  if @current_resource.isMember
    Chef::Log.info "#{@new_resource} is already a member - nothing to do."
  else
    converge_by("Joining new collective member #{@new_resource}") do
      joinMember(new_resource)
    end
  end
end

action :replicate do
  if @current_resource.isController
    Chef::Log.info "#{@new_resource} is already a controller - nothing to do."
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
  
end

def joinMember(new_resource)
  
end

def replicateController(new_resource)
  
end

def removeMember(new_resource)
  
end

def load_current_resource
  
end
