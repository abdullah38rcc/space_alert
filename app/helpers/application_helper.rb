module ApplicationHelper
	def is_active_controller(controller_name)
		if controller_name.is_a?(Array)
			return controller_name.include?(params[:controller]) ? "active" : nil
		end
		return params[:controller] == controller_name ? "active" : nil
	end

	def is_active_action(action_name)
		params[:action] == action_name ? "active" : nil
	end

	def get_bread_crumbs
		html_data="<ol class='breadcrumb'>"
		(render_breadcrumbs :separator => '||||').split("||||").each{ |bc| 
			html_data+="<li>#{bc}</li>"
		}
		html_data+="</ol>"
		return raw(html_data)
	end


	def calculate_value(model, method, options)
		unless options.include?(:as)
			return model.send(method)
		end

		case options[:as]
		when :boolean
			return true_false(model.send(method))
		when :value
			if options.include?(:value)
				return options[:value]
			end
		when :association
			if options.include?(:value)
				result = model.send(method).send(:try, options[:value])

				if options.include?(:link) and options[:link] and result
					result = link_to result, model.send(method)
				end

				return result
			end
		end

		return model.send(method)
	end

	def t_label(model, method)
		method = method.to_s if method.is_a?(Symbol)
		class_name = model.is_a?(Class) ? model.to_s.downcase : model.class.name.downcase

		label = t("active_record.attributes.#{class_name}.#{method}") 
		if label.include?("translation_missing")
			File.open(Rails.root.join("app/views/layouts/missing_translation.html.erb"), 'a+') { |file| file.write('<%=  t("active_record.attributes.'  + model.class.name.downcase + '.' + method + '") %>') }
		end

		return raw label
	end

	def display(model, method, options = {})
		result = "<dt><strong>"
		result += t_label(model, method)
		result += ":</strong></dt>"
		value	= calculate_value(model, method, options).to_s
		value	= "&nbsp;" if value.empty?
		result += "<dd>" + simple_format(value) + "</dd>"

		return raw result
	end
end
