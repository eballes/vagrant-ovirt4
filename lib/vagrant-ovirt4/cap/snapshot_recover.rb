module VagrantPlugins
  module OVirtProvider
    module Cap
      module SnapshotRecover
        def self.snapshot_recover(machine)
          env = machine.action(:snapshot_recover, lock: false)
          env[:machine_snapshot_recover]
        end
      end
    end
  end
end
