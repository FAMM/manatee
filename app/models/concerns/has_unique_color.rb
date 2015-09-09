module HasUniqueColor
  extend ActiveSupport::Concern

  included do
    COLORS = ["#00A0B0", "#6A4A3C", "#CC333F", "#EB6841", "#EDC951"]

    before_save :ensure_color
  end

  def ensure_color
    return unless color.blank?
    self.color = (COLORS - Category.where(:budget_id => budget_id).pluck(:color)).first
  end


  module ClassMethods
    def colors
      COLORS
    end
  end
end
