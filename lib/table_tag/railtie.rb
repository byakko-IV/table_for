require 'table_tag/table_helper'
module TableTag
  class Railtie < Rails::Railtie
    initializer "table_tag.table_helper" do
      ActionView::Base.send :include, TableHelper
    end
  end
end
