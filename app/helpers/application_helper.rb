module ApplicationHelper

    def show_errors_for_form(f)
        if f.object.errors.any?
            s = '<div id="error_explanation" class="alert alert-danger">'
            s += '<button type="button" class="close" data-dismiss="alert">&times;</button>'
            s += '<h4>Errors have been found</h4><ul>'
            f.object.errors.full_messages.each do |msg|
                s += "<li>#{msg}</li>"
            end
            s += "</ul></div>"
            raw s
        end
    end
     
end
