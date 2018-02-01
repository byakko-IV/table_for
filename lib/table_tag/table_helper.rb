module TableTag
  module TableHelper
    def table_for(collection, html_options={}, actions={}, fields={})
      Table.new(self, collection, html_options, actions, fields).table
    end

    class Table < Struct.new(:view, :data, :html_options, :actions, :fields)
      delegate :content_tag, to: :view

      def table
        if data.empty?
          content_tag :div do
            content_tag :h3, "table is empty!"
          end
        else
          content_tag :table, html_options do
            header + body
          end
        end
      end

      def header
        content_tag :thead do
          content_tag :tr do
            if fields.empty?
              head = data.first.attributes.keys.map { |title| content_tag :th, title }
              head.push content_tag(:th, "")
              head.join.html_safe
            else
              head = fields.values.map{ |title| content_tag :th, title }
              head << content_tag(:th, "", width: "15%")
              head.join.html_safe
            end
          end
        end
      end

      def body
        content_tag :tbody do
          data.map do |item|
            content_tag :tr do
              row(item)
            end
          end.join.html_safe
        end
      end

      def row(content)
        info = content.attributes.values.map { |attribute| content_tag(:td, attribute) } if fields.empty?
        info = fields.keys.map { |attribute| content_tag(:td, content.send(attribute)) } unless fields.empty?
        info << perform_actions(content)
        info.join.html_safe
      end

      def perform_actions(content)
        info = ""
        info += show_action(content, actions[:show]) if actions.has_key?(:show)
        info += edit_action(content, actions[:edit]) if actions.has_key?(:edit)
        info += delete_action(content, actions[:delete]) if actions.has_key?(:delete)
        content_tag :td, info.html_safe
      end

      def show_action(model, label)
        "<a href='/#{model.class.table_name.to_s}/#{model.id}'>#{label} </a>"
      end

      def edit_action(model, label)
        "<a href='/#{model.class.table_name.to_s}/#{model.id}/edit'>#{label} </a>"
      end

      def delete_action(model, label)
        "<a data-confirm='Are you sure?' rel='nofollow' data-method='delete' href='/#{model.class.table_name.to_s}/#{model.id}'>#{label} </a>"
      end
    end
  end
end
