module General
  extend ActiveSupport::Concern

  def type_name
    self.class.table_name.singularize.capitalize
  end

  def low_type_name
    self.class.table_name.singularize
  end
end