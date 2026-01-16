class StatementProcessingPolicy < ApplicationPolicy
    def statement?
        belongs_to_user?
    end
end
