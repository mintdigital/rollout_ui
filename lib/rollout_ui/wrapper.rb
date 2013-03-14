module RolloutUi
  class Wrapper
    class NoRolloutInstance < StandardError; end

    attr_reader :rollout

    def initialize(rollout = nil)
      @rollout = rollout || RolloutUi.rollout
      raise NoRolloutInstance unless @rollout
    end

    def groups
      rollout.instance_variable_get("@groups").keys
    end

    def add_feature(feature)
      rollout.send(:save, rollout.get(feature))
    end

    def features
      features = rollout.features.uniq
      features ? features.sort : []
    end

    def redis
      rollout.instance_variable_get("@storage")
    end
  end
end
