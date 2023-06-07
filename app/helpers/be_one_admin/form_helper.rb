module BeOneAdmin
  module FormHelper 
    def string_block( name, options = {} )
      input_block :text, name, options
    end
    def email_block( name, options = {} )
      input_block :email, name, options
    end
    def password_block( name, options = {} )
      input_block :text, name, options
    end
    def integer_block( name, options = {} )
      input_block :number, name, options
    end
    def hidden_block( name, options = {} )
      input_block :hidden, name, options
    end

    def tabs_block tabs, &block

      content_tag(:div,class:"lang-tabs",ng_controller: "TabsController",ng_init: "steps = {'#{tabs.first}': true}") do

        concat(content_tag(:ul,class:"nav nav-tabs") do
          tabs.map do |tab|
            content_tag(:li, class:"nav-items", ng_click:"toggleTab('#{tab}')" ) do
              content_tag(:a,href: "javascript:;",class:"nav-link show",ng_click:"toggleTab('#{tab}')", ng_class:"{'active': steps['#{tab}'],'show': steps['#{tab}']}") do 
                concat content_tag(:span,nil, class: "d-sm-none" )
                concat content_tag(:span,_placeholder("tabs.#{tab}"), class: "d-sm-block d-none" )
              end
            end
          end.join.html_safe
        end)
        concat(
          content_tag(:div,class:"tab-content") do
            tabs.map do |tab|
              content_tag(:div, class: "tab-pane fade", ng_class:"{'active': steps['#{tab}'],'show': steps['#{tab}']}" ) do
                block.call(tab)
              end
            end.join.html_safe
          end
        )
      end

    end


    def lang_tabs_block
      content_tag(:div,class:"bwizard") do
        content_tag(:ul,class:"bwizard-steps clickable") do
          I18n.available_locales.map do |locale|
            content_tag(:li, ng_class:"{'active': steps['#{locale}']}", ng_click:"toggleTab('#{locale}')" ) do
              content_tag(:a,href: "javascript:;",class:"hidden-phone",ng_click:"toggleTab('#{locale}')") do 
                concat locale.upcase
                concat content_tag(:span,nil, class: "flag-icon flag-icon-squared flag-icon-#{locale}" )
              end
            end
          end.join.html_safe
        end
      end
    end

    def lang_tabs_block_v2 &block

      content_tag(:div,class:"lang-tabs",ng_controller: "TabsController",ng_init: "steps = {'#{I18n.locale}': true}") do

        concat(content_tag(:ul,class:"nav nav-tabs") do
          I18n.available_locales.map do |locale|
            content_tag(:li, class:"nav-items", ng_click:"toggleTab('#{locale}')" ) do
              content_tag(:a,href: "javascript:;",class:"nav-link show",ng_click:"toggleTab('#{locale}')", ng_class:"{'active': steps['#{locale}'],'show': steps['#{locale}']}") do 
                concat content_tag(:span,nil, class: "d-sm-none flag-icon flag-icon-squared flag-icon-#{locale}" )
                concat content_tag(:span,nil, class: "d-sm-block d-none flag-icon flag-icon-squared flag-icon-#{locale}" )
              end
            end
          end.join.html_safe
        end)
        concat(
          content_tag(:div,class:"tab-content") do
            I18n.available_locales.map do |locale|
              content_tag(:div, class: "tab-pane fade", ng_class:"{'active': steps['#{locale}'],'show': steps['#{locale}']}" ) do
                block.call(locale)
              end
            end.join.html_safe
          end
        )


      end

    end

    def input_for_lang_tabs( type, field, locale, options = {} )
      defaults = {
        placeholder: "#{_placeholder(field)} #{locale.upcase}",
        class: "form-control",
        ng_model: "editedItem.#{field}.#{locale}",
        ng_minlength: 2,
        ng_disabled: "isDisabled",
        autocomplete: "off",
        type: type
      }
      options = defaults.merge options
      content_tag(:div,class:"form-group") do
        concat content_tag(:label,"#{_placeholder(field)} #{locale.upcase}", {for: field} )
        concat text_field_tag( :"#{field}.#{locale}", nil, options )
      end
    end

    def text_area_for_lang_tabs( field, locale, options = {} )
      defaults = {
        placeholder: "#{_placeholder(field)} #{locale.upcase}",
        class: "form-control",
        ng_model: "editedItem.#{field}.#{locale}",
        rows: 5,
        ng_disabled: "isDisabled",
      }
      options = defaults.merge options
      content_tag(:div,class:"form-group") do
        concat content_tag(:label,"#{_placeholder(field)} #{locale.upcase}", {for: field} )
        concat text_area_tag( :"#{field}.#{locale}", nil, options )
      end
    end

    def translated_block(field, options = {}, textarea = false)

      defaults = {
        placeholder: _placeholder(field),
        class: "form-control",
        ng_minlength: 3,
        required: true,
        ng_disabled: "isDisabled"
      }
      options = defaults.merge options
      [content_tag(:div,class:"form-group") do
        content_tag(:label,  _placeholder(field), {for: field} )
      end,
      I18n.available_locales.map do |locale|
        content_tag(:div,class:"form-group") do
           content_tag(:div,class:"row") do
            (content_tag(:div,class:"col-md-1 col-xs-1") do
              content_tag(:span,nil,class:"flag-icon flag-icon-squared flag-icon-#{locale}",style: "height: 25px;width: 30px;")
            end) +
            (content_tag(:div,class:"col-md-11 col-xs-11") do
              if textarea
                text_area_tag(:"#{field}.#{locale}", nil, options.merge(ng_model: "editedItem.#{field}.#{locale}", ))
              else
                text_field_tag(:"#{field}.#{locale}", nil, options.merge(ng_model: "editedItem.#{field}.#{locale}", ))
              end
            end)
          end
        end
      end].join.html_safe

    end

    def image_block( field, options = {} )
      defaults = {
        class: "ng-cloak ng-hide",
        ng_model: "editedItem.#{field}",
        ng_minlength: 2,
        rows: 5,
        ng_disabled: "isDisabled",
        ng_show:"!isDisabled",
        ng_file_select: "onFileSelect($files)",
        style: "display: block;"
      }
      options = defaults.merge options

      content_tag(:div,class:"form-group") do
        concat content_tag(:label, _placeholder(field), {for: field} )
        concat(
          content_tag(:div,class:"text-center") do
            concat(file_field_tag( :"#{field}", options ))
            concat(image_tag("", {class: "avatar-image", ng_src: "{{ editedItem.#{field} || 'https://upload.wikimedia.org/wikipedia/commons/1/1e/Default-avatar.jpg' }}"}))
          end
        )

      end


    end

    def translated_text_block( field, options = {} )
      translated_block(field, options, true)
    end
    def tags_block(field, options = {}, with_complete = false, complete_options = {})
      options = {
        placeholder: _placeholder(field),
        ng_model: "editedItem.#{field}_tags",
        id: "#{field}_tags",
        ng_disabled: 'isDisabled',
        'min-tags' => 1,
        'min-length' => 1,
        'add-on-space' => :true,
        'add-from-autocomplete-only' => with_complete ? :true : :false
      }.merge(options)

      complete_options = {
        source: "loadTags($query, '#{field}')",
        'load-on-click' => :false,
        'load-on-empty' => :true,
        'load-on-focus' => :true,
        'min-length' => 0,
        'max-results-to-show' => 1000
      }.merge(complete_options)

      content_tag(:div, class: :'form-group') do
        concat content_tag(:label, _placeholder(field), { for: field })
        if with_complete
          concat content_tag(:'tags-input', tag(:'auto-complete', complete_options), options)
        else
          concat tag(:'tags-input', options)
        end
      end
    end

    def rich_text_editor( field, locale, options = {} )
      text_block(field,{ng_model: "editedItem.#{field}['#{locale}']",mce_editor: "editedItem.#{field}['#{locale}']",class: "mce-editor hidden"}.merge(options))
    end

    def text_block( field, options = {} )
      defaults = {
        placeholder: _placeholder(field),
        class: "form-control",
        ng_model: "editedItem.#{field}",
        ng_minlength: 2,
        rows: 5,
        ng_required: options[:ng_required].presence || options[:required].presence,
        ng_disabled: "isDisabled",
      }
      options = defaults.merge options
      content_tag(:div,class:"form-group") do
        concat content_tag(:label, _placeholder(field), {for: field} )
        concat text_area_tag( :"#{field}", nil, options )
      end
    end

    def date_block(field, options = {})
      options = {
        'datetime-picker' => 'dd.MM.yyyy',
        'enable-time' => 'false',
        'is-open' => "pickers['#{field}']",
        'datepicker-options' => 'DateOptions',
        'save-as' => true,
        'read-as' => true,
        'initial-picker' => 'date',
        class: 'form-control date-field',
        readonly: true,
        field: field.kind_of?(Symbol) ? "'#{field}'" : "#{field}",
        ng_click: "openCalendar($event, #{options[:field] || field})",
        ng_required: :false,
        min_date: ''
      }.merge(options)

      button = content_tag(:span, class: 'input-group-addon', ng_click: "openCalendar($event, #{options[:field]},#{options[:ng_required]})" ) do
        content_tag(:i, nil, class: 'fa fa-calendar pointer')
      end

      input_block(:string, field, options, button)
    end

    def date_time_block(field, options = {})
      date_block(field, { 'enable-time' => 'true', 'datetime-picker' => 'dd.MM.yyyy HH:mm' }.merge(options))
    end
    def state_block( field, options = {} )
      defaults = {
        ng_model: "editedItem.#{field}",
        ng_disabled: "isDisabled",
        name: field,
        id: options[:field] || field,
        type: 'checkbox'
      }
      options = defaults.merge options
      content_tag(:div,class:"form-group") do
        content_tag(:div,class:"checkbox checkbox-css checkbox-inline") do
          concat tag(:input, options)
          concat content_tag(:label, _placeholder(field), {for: "#{options[:id]}"} )
        end
      end
    end

    def checkboxes_block(field, chunk_size, col_size, options = {})

      content_tag(:div,class:"row",ng_repeat: "group in #{field} | group_chunk:#{chunk_size}") do
        content_tag(:div,class:"col-md-#{col_size}", ng_repeat: "item in group") do

          options = {
            ng_model: "editedItem.#{field.to_s.singularize}[item.id]",
            name: "#{field}[{{item.id}}]",
            id: "#{field}_{{item.id}}",
            type: 'checkbox'
          }
          content_tag(:div, class: "checkbox checkbox-css checkbox-inline") do 
            concat tag(:input, options)
            concat content_tag(:label, "{{item.title}}", {for: "#{field}_{{item.id}}"} )
          end
        end
      end
    end

    def file_manager_block(field)
      content_tag(:div,class:"form-group") do
        concat(content_tag(:div,class:"preview row") do
          content_tag(:div, class:"previewData col-md-3", ng_repeat: "item in editedItem.#{field} track by $index") do
            concat(content_tag(:a, href:"{{item.src}}", download: "download") do
              concat content_tag(:div, "{{item.filename}}")
              concat tag(:img, ng_src:"{{item.src}}", onerror: "this.src='https://cdn3.iconfinder.com/data/icons/files-44/32/File_Link-512.png';")
            end)
              concat( content_tag(:span, tag(:i, class: "fa fa-close"), class: "circle remove", ng_click:"removeAttach(item)"))
          end
        end)
        concat content_tag(:div, nil, "img-upload": true, files: "editedItem.#{field}_base64_data" )
      end
    end

    def select_block( field, items_name, options = {} )
      ng_options = if options.delete(:grouped)
        "item.id as item.title group by item.parent_id for item in #{items_name}"
      else
        "item.id as item.title for item in #{items_name}"
      end
      defaults = {
        placeholder: _placeholder(field),
        class: "form-control",
        ng_model: "editedItem.#{field}",
        ng_options: ng_options,
        ng_disabled: "isDisabled",
        required: true,
        ng_required: "true",
        name: field
      }
      options = defaults.merge options
      content_tag(:div,class:"form-group") do
        concat content_tag(:label, _placeholder(field), {for: field} )
        concat content_tag(:select, nil, options)
      end

    end

    def search_block(field, items, options = {})
      options = {
        placeholder: _placeholder(field),
        ng_model: "editedItem.#{field}"
      }.merge(options)

      repeat = "item.value.value as (key, item) in #{items} | filter: { value: { title: $select.search } }"

      content_tag(:div, class: 'form-group') do
        concat content_tag(:label, _placeholder(field), for: field)
        concat(
          content_tag('ui-select', options.except(:placeholder)) do
            concat(content_tag('ui-select-match', '{{ $select.selected.value.title }}', placeholder: options[:placeholder]))
            concat(
              content_tag('ui-select-choices', repeat: repeat) do
                tag.div(ng_bind_html: "item.value.title | highlight: $select.search")
              end
            )
          end
        )
      end
    end

    def ol_map_block(map_zoom: 10, has_address_field: true, allow_drag: true, lat_options: {}, lng_options: {}, address_options: {})
      content_tag(:div, ng_controller: 'OLMapController as vm') do
        concat(content_tag(:div, class: 'row') do
          concat(content_tag(:div, class: "col-md-#{has_address_field ? 4 : 6} form-group") do
            field_options = {
              class: 'form-control',
              ng_required: 'true',
              required: true,
              ng_model: '$parent.editedItem.latitude',
              readonly: true,
              tooltip_enable: 'itemForm.$submitted && itemForm.latitude.$error.required',
              tooltip_is_open: 'itemForm.$submitted && itemForm.latitude.$error.required',
              uib_tooltip: t('#{BeOneAdmin.config.class_name.downcase}.tooltips.empty_address_coordinates')
            }.merge(lat_options)

            concat content_tag(:label, _placeholder(:latitude), { for: :latitude })
            concat number_field_tag(:latitude, nil, field_options)
          end)

          concat(content_tag(:div, class: "col-md-#{has_address_field ? 4 : 6} form-group") do
            field_options = {
              class: 'form-control',
              ng_model: '$parent.editedItem.longitude',
              ng_required: 'true',
              required: true,
              readonly: true
            }.merge(lng_options)

            concat content_tag(:label, _placeholder(:longitude), { for: :longitude })
            concat number_field_tag(:longitude, nil, field_options)
          end)

          if has_address_field
            concat(content_tag(:div, class: 'col-md-4 form-group') do
              concat content_tag(:label, _placeholder(:address), { for: :address })
              concat(content_tag(:p, class: 'input-group') do
                field_options = {
                  class: 'form-control', ng_model: 'address', ng_keyup: '$event.keyCode == 13 ? getLocation() : null'
                }.merge(address_options)

                concat text_field_tag(:address, nil, field_options)
                concat(content_tag(:span, class: 'input-group-addon', role: 'button', ng_click: 'getLocation()') do
                  content_tag(:i, nil, class: 'fa fa-map-marker pointer')
                end)
              end)
            end)
          end
        end)

        concat(content_tag(:div, class: 'row') do
          content_tag(:div, class: 'col-md-12 form-group') do
            # concat content_tag(:label, _placeholder(:location), { for: :location })
            concat content_tag(:div, nil, id: 'map', style: 'height: 400px;', ng_init: 'initMap()', data: { zoom: map_zoom, drag: allow_drag })
          end
        end)
      end
    end

    def map_block( options = {}, has_address_line = true )
      defaults = {
        "zoom" => 15,
        "map-type-id"=>"ROADMAP",
        "center"=>"{{markerPosition}}",
      }

      lazy_options = {
        "map-lazy-load"=>"https://maps.google.com/maps/api/js",
        "map-lazy-load-params"=>"https://maps.googleapis.com/maps/api/js?key=AIzaSyApKxx6WJb2xECnnUwJJ7t_1ELGKzLcnEY&language=#{I18n.locale}",
      }
      options = defaults.merge options
      number_field_options = { class: "form-control",ng_required: 'true', required: true, ng_model: "$parent.editedItem.latitude", readonly: true }
      number_field_options.merge!(tooltip_enable: 'itemForm.$submitted && itemForm.latitude.$error.required',
                                  tooltip_is_open: 'itemForm.$submitted && itemForm.latitude.$error.required',
                                  uib_tooltip: t("#{BeOneAdmin.config.class_name.downcase}.tooltips.empty_address_coordinates")) if has_address_line

      content_tag(:div, class:"row", ng_controller: "MapController as vm") do
        divs = []
        divs << content_tag(:div,class: "col-md-#{has_address_line ? 4 : 6}") do
          content_tag(:div,class:"form-group") do
            concat content_tag(:label, _placeholder(:latitude), {for: :latitude} )
            concat number_field_tag(:latitude, nil, number_field_options)
          end
        end
        divs << content_tag(:div,class: "col-md-#{has_address_line ? 4 : 6}") do
          content_tag(:div,class:"form-group") do
            concat content_tag(:label, _placeholder(:longitude), {for: :longitude} )
            concat number_field_tag(:longitude, nil, {class: "form-control",ng_required: 'true', required: true, ng_model: "$parent.editedItem.longitude",readonly: true})
          end
        end
        if has_address_line
          divs << content_tag(:div,class: "col-md-4") do
            content_tag(:div,class:"form-group") do
              content_tag(:label, _placeholder(:address), {for: :address} ) + (content_tag(:p,class:"input-group") do
                [text_field_tag( :address, nil, {class: "form-control",ng_model: "address"} ) ,
                content_tag(:span, class:"input-group-addon",ng_click:"getLocation()" ) do
                  content_tag(:i,nil,class:"fa fa-google pointer")
                end].join.html_safe
              end)
            end
          end
        end
        divs << content_tag(:div,class:"col-md-12") do
          content_tag(:div,class:"form-group") do
            content_tag(:label, _placeholder(:location), {for: :location} ) + content_tag(:div,lazy_options) do
              content_tag("ng-map", options) do
                tag("marker",{draggable: "true", position: "{{markerPosition}}", animation:"Animation.BOUNCE", "on-dragend" => "getCurrentLocation()"} )
              end

            end
          end
        end
        divs.join.html_safe
      end
    end

    def plus_button( options = {} )
      defaults = {
        class: "btn btn-primary",
        ng_click: "addRow()"
      }
      options = defaults.merge(options)
      content_tag(:div,class:"form-group") do

         content_tag(:label, t("#{BeOneAdmin.config.class_name.downcase}.add_new")  ) + content_tag(:a,options) do
          tag(:i,class:"fa fa-plus")
        end
      end
    end

    def minus_button( options= {} )
      defaults = {
        class: "btn btn-danger",
        ng_click: "deleteRow($index)"
      }
      options = defaults.merge(options)
      content_tag(:div,class:"form-group") do

         content_tag(:label, t("#{BeOneAdmin.config.class_name.downcase}.modules._actions.destroy")  ) + content_tag(:a,options) do
          tag(:i,class:"fa fa-minus")
        end
      end
    end


    def yes_no_filter( field )
      content_tag(:div,class:"form-group") do
        concat content_tag(:label, t("#{BeOneAdmin.config.class_name.downcase}.filter.#{field}"), {for: field} )
        concat select_tag( :blocked, options_for_select(t("#{BeOneAdmin.config.class_name.downcase}.filter.state"),0), class: 'form-control', ng_model: "filters.#{field}",  data: { compare: :equal } )
      end
    end

    def select_filter(field, options)
      content_tag(:div, class: 'form-group') do
        concat content_tag(:label, _placeholder(field) , { for: field } )
        concat select_tag(
                 field, options_for_select(choose.concat options),
                 class: 'form-control', ng_model: "filters.#{field}_eq"
               )
      end
    end

    def text_filter(field, placeholder = nil)
      content_tag(:div, class: 'form-group') do
        concat content_tag(:label, placeholder || _placeholder(field), { for: field })
        concat text_field_tag(
                 :"#{field}", nil,
                 placeholder: placeholder || _placeholder(field),
                 class: 'form-control',
                 ng_model: "filters.#{field}_matches",
                 ng_minlength: 2,
                 on_enter: 'filter()'
               )
      end
    end


    def state_block_filter( field, options = {} )
      defaults = {
        ng_model: "filters.#{field}",
        ng_disabled: "isDisabled",
        name: field,
        id: options[:field] || field,
        type: 'checkbox'
      }
      options = defaults.merge options
      content_tag(:div,class:"form-group") do
        content_tag(:div,class:"checkbox checkbox-css checkbox-inline") do
          concat tag(:input, options)
          concat content_tag(:label, _placeholder(field), {for: "#{options[:id]}"} )
        end
      end
    end
    

    def number_filter(field, placeholder: nil, operation: nil)
      content_tag(:div, class: 'form-group') do
        concat content_tag(:label, placeholder || _placeholder(field), { for: field })
        concat number_field_tag(
                 :"#{field}", nil,
                 placeholder: placeholder || _placeholder(field),
                 class: 'form-control',
                 ng_model: operation ? "filters.#{field}_#{operation}" : "filters.#{field}",
                 ng_min: 0,
                 on_enter: 'filter()'
               )
      end
    end

    # @params field [String] - name of filtering field
    # @params items [Array[Hashes]] - array of objects for title and value
    # @params options [Hash]- additional params
    # @return [html] - ui-select element
    def search_filter(field, items, options = {})
      options = {
        placeholder: _placeholder(field),
        ng_model: "filters.#{field}"
      }.merge(options)

      repeat = "item.value.value as (key, item) in #{items} | filter: { value: { title: $select.search } }"

      content_tag(:div, class: 'form-group') do
        concat(content_tag(:label, options[:placeholder], for: field))
        concat(
          content_tag('ui-select', options.except(:placeholder)) do
            concat(content_tag('ui-select-match', '{{ $select.selected.value.title }}', placeholder: options[:placeholder]))
            concat(
              content_tag('ui-select-choices', repeat: repeat) do
                tag.div(ng_bind_html: "item.value.title | highlight: $select.search")
              end
            )
          end
        )
      end
    end

    def date_filter(field, options = {})
      defaults = {
        "datetime-picker" => "dd.MM.yyyy",
        "enable-time"=>"false",
        "is-open" => "pickers['#{field}']",
        "datepicker-options"=>"DateOptions",
        'save-as' => true,
        'read-as' => true,
        'block-align' => 'right',
        "initial-picker" => 'date',
        class: "form-control date-field",
        readonly: true,
        field: field.kind_of?(Symbol) ? "'#{field}'" : "#{field}",
        ng_click: "openCalendar($event, #{options[:field] || field})",
        ng_model: "filters.#{field}"
      }
      options = defaults.merge options
      button = content_tag(:span, class:"input-group-addon", ng_click: "openCalendar($event, #{options[:field]})" ) do
        content_tag(:i,nil,class:"fa fa-calendar pointer")
      end
      input_block( :string, field, options,button )
    end

    def range_date_time_filter( field, options = {} )
      content_tag(:div,class:"row") do
        ["gte","lte"].map do |sufix|
          content_tag(:div,class:"col-md-6") do
            defaults = {
              style: "color: black!important;font-weight: 600;",
              "datetime-picker" => "yyyy-MM-dd",
              "enable-time"=>"false",
              "is-open" => "pickers['#{field}_#{sufix}']",
              "datepicker-options"=>"DateOptions#{sufix.capitalize}#{field.to_s.capitalize}",
              'save-as' => true,
              'read-as' => true,
              'block-align' => 'right',
              "initial-picker" => 'date',
              ng_change: "onChange#{sufix.capitalize}('#{field}')",
              class: "form-control date-field",
              readonly: true,
              ng_click: "openCalendar($event, '#{field}_#{sufix}')",
              ng_model: "filters.#{field}_#{sufix}"
            }
            _options = defaults.merge options
            button = content_tag(:span, class:"input-group-addon", ng_click: "openCalendar($event, '#{field}_#{sufix}')" ) do
              concat(content_tag(:i,nil,class:"fa fa-calendar pointer"))
            end
            string_block("#{field}_#{sufix}",_options)
          end
        end.join.html_safe
      end
    end


    def choose
      [[I18n.t("#{BeOneAdmin.config.class_name.downcase}.choose"),nil]]
    end

    def choose_all
      [[I18n.t("#{BeOneAdmin.config.class_name.downcase}.common"),nil]]
    end

    def form_choose( id = 0 )
      [{id: id, title: I18n.t("#{BeOneAdmin.config.class_name.downcase}.choose") }]
    end

    def form_choose_all( id = 0 )
      [{id: id, title: I18n.t("#{BeOneAdmin.config.class_name.downcase}.common") }]
    end

    def to_select_options( klass, title_key = :title )
      klass.select("id,#{title_key}").all.map do |item|
        {
          id: item.id,
          title: item.send(title_key)
        }
      end
    end

    def to_filter_options( klass, title_key = :title )
      klass.select("id,#{title_key}").all.map{ |item| [ item.send(title_key), item.id ] }
    end

    def to_nested_select_options( klass, nested_klass, title_key = :title, second_netned = false )
      klass.select("id,#{title_key}").all.map do |item|
        {
          id: item.id,
          title: item.send(title_key),
          items: item.send(nested_klass).map do |i|
            {id: i.id, title: i.send(title_key), items:( second_netned ? i.send(second_netned).map{|n| {id: n.id, title: n.send(title_key)} } : [] ) }
          end
        }
      end
    end

    private 

    def input_block( type, field, options = {}, block = nil )
      defaults = {
        placeholder: _placeholder(field),
        class: "form-control",
        ng_model: "editedItem.#{field}",
        ng_minlength: 2,
        ng_disabled: "isDisabled",
        ng_required: options[:ng_required].presence || options[:required],
        autocomplete: "off",
        type: type
      }
      options = defaults.merge options
      content_tag(:div,class:"form-group") do
        if block
          content_tag(:label, _placeholder(field), {for: field} ) + (content_tag(:p,class:"input-group") do
            concat(text_field_tag( :"#{field}", nil, options ))
            concat(block)
          end)
        else
          concat content_tag(:label, _placeholder(field), {for: field} )
          concat text_field_tag( :"#{field}", nil, options )
        end
      end
    end


    def _placeholder(name)
      I18n.t("#{BeOneAdmin.config.class_name.downcase}.modules.#{params[:controller].split('/').last.singularize}_#{name}")
    end

  end
end