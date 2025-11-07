class SubcategoryPolicy < ApplicationPolicy
    def index?
        belongs_to_user?
    end
end
