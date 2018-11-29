module VagrantPlugins
  module OVirtProvider
    module Action
      class SnapshotRecover
        def initialize(app, env)
          @logger = Log4r::Logger.new("vagrant_ovirt4::action::snapshot_recover")
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_ovirt4.snapshot_recover"))

          system_service = env[:connection].system_service

          # Find all the virtual machines and store the id and name in a
          # hash, so that looking them up later will be faster:
          vms_map = Hash[env[:vms_service].list.map { |vm| [vm.id, vm.name] }]

          # For each VM
          vms_map.each do |vm_id, vm_name|

            # Find the snapshot. Note that the snapshots collection doesn't support search, 
            # so we need to retrieve the complete list and the look for the snapshot that 
            # has the description that we are looking for.              
            snaps_service = vm_service.snapshots_service                                                        
            snap = snaps_service.list.detect { |s| s.description == env[:snapshot_name] }  

            # Stop it
            vm_service = env[:vms_service].vm_service(vm_id)
            vm_service.stop
            loop do
              sleep(5)
              vm = vm_service.get
              break if vm.status == OvirtSDK4::VmStatus::DOWN
            end


            # Restore snapshot
            snap.restore(
                restore_memory: False,
                async: False
            )

            # Start machine
            vm_service.start
            loop do
              sleep(5)
              vm = vm_service.get
              break if vm.status == OvirtSDK4::VmStatus::UP
            end
          end

          @app.call(env)
        end
      end
    end
  end
end
