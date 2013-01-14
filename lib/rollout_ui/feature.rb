module RolloutUi
  class Feature
    User = Struct.new(:id)

    attr_reader :name

    def initialize(name)
      @wrapper = Wrapper.new
      @name = name
    end

    def percentage
      rollout_feature.percentage
    end

    def groups
      rollout_feature.groups
    end

    def user_ids
      rollout_feature.users
    end

    def percentage=(percentage)
      rollout.activate_percentage(name, percentage)
    end

    def groups=(groups)
      self.groups.each { |old_group| rollout.deactivate_group(name, old_group) }
      groups.each { |group| rollout.activate_group(name, group) unless group.to_s.empty? }
    end

    def user_ids=(ids)
      self.user_ids.each { |old_id| rollout.deactivate_user(name, User.new(old_id)) }
      ids.each { |id| rollout.activate_user(name, User.new(id)) unless id.to_s.empty? }
    end

  private

    def redis
      @wrapper.redis
    end

    def rollout
      @wrapper.rollout
    end

    def rollout_feature
      rollout.get(name)
    end

  end
end
