# frozen_string_literal: true

#
# Cookbook:: rasposmc
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'rasposmc::transmission'
include_recipe 'rasposmc::sickrage'
include_recipe 'rasposmc::noip'
