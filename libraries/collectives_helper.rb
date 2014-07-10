# Cookbook Name:: wlp
# Attributes:: default
#
# (C) Copyright IBM Corporation 2013.
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

module Liberty
  class CollectivesHelper
    
    def initialize(node)
      @utils = Utils.new(node)
    end
    
    def exists?(server_name)
      return @utils.serverDirectoryExists?(server_name)
    end

    def join(member_name, host, port, user, password, keystorePassword)
      if exists?(server_name)
        command = "join #{server_name} --host=#{host} --port=#{port} --user=#{user} --password=#{password} --keystorePassword=#{keystorePassword}"
        join = runCommand(command)
        join.error!
        return true
      else
        return false
      end
    end

    private

    def runCommand(arguments) 
      command = Mixlib::ShellOut.new("#{@utils.installDirectory}/bin/collective #{arguments}", :user => @utils.user, :group => @utils.group)
      command.run_command
    end
    
  end
end
