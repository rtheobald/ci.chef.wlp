# Cookbook Name:: wlp_test
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

include_recipe "wlp_ibm::default"

wlp_install_feature "mongodb" do
  location "http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.5.1/com.ibm.websphere.appserver.mongodb-2.0.esa"
  accept_license true
end

wlp_server "testServer" do
  config ({
            "featureManager" => {
              "onError" => "FAIL", 
              "feature" => [ "jsp-2.2", "mongodb-2.0" ]
            },
            "httpEndpoint" => {
              "id" => "defaultHttpEndpoint",
              "host" => "*",
              "httpPort" => "9080",
              "httpsPort" => "9443"
            }
          })
  action [:create, :start]
end
