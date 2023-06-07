Install<br/>
docker-compose run app rails generate be_one_admin:install

Reset all data<br/>
docker-compose run app rake be_one_admin:reset

Recreate menu<br/>
docker-compose run app rake be_one_admin:recreate_menu


Generate model with operation<br/>
docker-compose run app rails generate be_one_core:operation MODEL NAMESPACE<br/>
docker-compose run app rails generate be_one_admin:component MODEL NAMESPACE<br/><br/>



#= require be_one_admin/angular/controllers/base_controller


Serializer <br/>
      translated *args
      hidden *args
      as_tags *args
      as_string *args
      as_image *args
      as_images *args
      as_checkboxes *args
      ham_many_attributes *args
      image_path(instance, default = nil, resize = nil )



FormHelper
string_block( name, options = {} )
email_block( name, options = {} )
password_block( name, options = {} )
integer_block( name, options = {} )
hidden_block( name, options = {} )
image_block( name, options = {} )
tags_block(name, options = {}, with_complete = false, complete_options = {})
date_block(field, options = {})
date_time_block(field, options = {})
state_block( field, options = {} )
checkboxes_block(field, chunk_size, col_size, options = {})
galery_block(field)
select_block( field, items_name, options = {} )
search_block(field, items, options = {})
ol_map_block(map_zoom: 10, has_address_field: true, allow_drag: true, lat_options: {}, lng_options: {}, address_options: {})
map_block( options = {}, has_address_line = true )
plus_button( options = {} )
minus_button( options= {} )
text_block( field, options = {} )
rich_text_editor( field, locale, options = {} )
translated_text_block( field, options = {} )
translated_block(field, options = {}, textarea = false)

yes_no_filter( field )
select_filter(field, options)
text_filter(field, placeholder = nil)
number_filter(field, placeholder: nil, operation: nil)
search_filter(field, items, options = {})
date_filter(field, options = {})
range_date_time_filter( field, options = {} )

lang_tabs_block_v2 &block - locale
input_for_lang_tabs( type, field, locale, options = {} )
text_area_for_lang_tabs( field, locale, options = {} )

tabs_block( tabs, &block ) - tab


