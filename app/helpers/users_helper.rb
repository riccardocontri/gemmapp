module UsersHelper
    def gravatar_for(user, options = { :size => 50 })
        gravatar_image_tag(
            user.email.downcase, #TODO ??? Forzarlo sempre a downcase al momento del salvataggio?
            :alt => h(user.name),
            :class => "gravatar",
            :gravatar => options)
    end
end
