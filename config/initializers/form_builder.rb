class ActionView::Helpers::FormBuilder
    alias :orig_label :label

    # add a '*' after the field label if the field is required
    def label(method, content_or_options = nil, options = nil, &block)
        content, options =
            add_mark_to_required_attrs(method, content_or_options, options, &block)
        self.orig_label(method, content, options || {}, &block)
    end

    private
        def add_mark_to_required_attrs(method, content_or_options = nil, options = nil, &block)
            if content_or_options && content_or_options.class == Hash
                options = content_or_options
            else
                content = content_or_options
            end
            content ||= method.to_s.humanize #oppure content ||= I18n.t("activerecord.attributes.#{object.class.name.underscore}.#{method}", :default=>method.to_s.humanize)
            content += ' *'.html_safe if
                !object.nil? &&
                object.class.validators_on(method).map(&:class).include?(
                    ActiveModel::Validations::PresenceValidator)
            
            return content, options
        end
end
