require 'vagrant'
require 'filesize'
require 'ovirtsdk4'

module VagrantPlugins
  module OVirtProvider
    class Config < Vagrant.plugin('2', :config)

      attr_accessor :url
      attr_accessor :username
      attr_accessor :password
      attr_accessor :insecure
      attr_accessor :debug
      attr_accessor :filtered_api
      attr_accessor :cpu_cores
      attr_accessor :cpu_sockets
      attr_accessor :cpu_threads
      attr_accessor :template
      attr_accessor :memory_size
      attr_accessor :memory_maximum
      attr_accessor :memory_guaranteed
      attr_accessor :cluster
      attr_accessor :console
      attr_accessor :cloud_init
      attr_accessor :affinity
      attr_accessor :placement_host
      attr_accessor :bios_serial
      attr_accessor :optimized_for

      def initialize
        @url               = UNSET_VALUE
        @username          = UNSET_VALUE
        @password          = UNSET_VALUE
        @insecure          = UNSET_VALUE
        @debug             = UNSET_VALUE
        @filtered_api      = UNSET_VALUE
        @cpu_cores         = UNSET_VALUE
        @cpu_sockets       = UNSET_VALUE
        @cpu_threads       = UNSET_VALUE
        @template          = UNSET_VALUE
        @memory_size       = UNSET_VALUE
        @memory_maximum    = UNSET_VALUE
        @memory_guaranteed = UNSET_VALUE
        @cluster           = UNSET_VALUE
        @console           = UNSET_VALUE
        @cloud_init        = UNSET_VALUE
        @affinity          = UNSET_VALUE
        @placement_host    = UNSET_VALUE
        @bios_serial       = UNSET_VALUE
        @optimized_for     = UNSET_VALUE

      end

      def finalize!
        @url = nil if @url == UNSET_VALUE
        @username = nil if @username == UNSET_VALUE
        @password = nil if @password == UNSET_VALUE
        @insecure = false if @insecure == UNSET_VALUE
        @debug = false if @debug == UNSET_VALUE
        @filtered_api = false if @filtered_api == UNSET_VALUE
        @cpu_cores = 1 if @cpu_cores == UNSET_VALUE
        @cpu_sockets = 1 if @cpu_sockets == UNSET_VALUE
        @cpu_threads = 1 if @cpu_threads == UNSET_VALUE
        @cluster = nil if @cluster == UNSET_VALUE
        @console = nil if @console == UNSET_VALUE
        @memory_size = '256 MB' if @memory_size == UNSET_VALUE
        @memory_maximum = @memory_size if @memory_maximum == UNSET_VALUE
        @memory_guaranteed = @memory_size if @memory_guaranteed == UNSET_VALUE
        @template = nil if @template == UNSET_VALUE
        @cloud_init = nil if @cloud_init == UNSET_VALUE
        @affinity = nil if @affinity == UNSET_VALUE
        @placement_host = nil if @placement_host == UNSET_VALUE
        @bios_serial = nil if @bios_serial == UNSET_VALUE
        @optimized_for = nil if @optimized_for == UNSET_VALUE

        unless optimized_for.nil?
          raise "Invalid 'optimized_for'. Must be one of #{OvirtSDK4::VmType.constants.map { |s| "'#{s.downcase}'" }.join(' ')}" unless OvirtSDK4::VmType.constants.include? optimized_for.upcase.to_sym
        end

        unless affinity.nil?
          raise "Invalid affinity. Must be one of #{OvirtSDK4::VmAffinity.constants.map { |s| "'#{s.downcase}'" }.join(' ')}" unless OvirtSDK4::VmAffinity.constants.include? affinity.upcase.to_sym
        end

        begin
          @memory_size = Filesize.from(@memory_size).to_f('B').to_i
          @memory_maximum = Filesize.from(@memory_maximum).to_f('B').to_i
          @memory_guaranteed = Filesize.from(@memory_guaranteed).to_f('B').to_i
        rescue ArgumentError 
          raise "Not able to parse either `memory_size` or `memory_guaranteed`. Please verify and check again."
        end
      end

    end
  end
end

