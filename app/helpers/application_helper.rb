# frozen_string_literal: true

# This module provides helper methods that can be used in views and controllers.
module ApplicationHelper
  # Returns the human attribute name per the models support of i18n.
  # In a real app, you might want to invest time in presenter classes if there are complex view needs.
  def han(model, *args)
    model.class.human_attribute_name(
      args.map(&:to_s).join('.')
    )
  end
end
