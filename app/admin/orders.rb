ActiveAdmin.register Order do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  permit_params :title, :phone, :email, :comment, :status

  show do
    attributes_table do
      row :title
      row :phone
      row :email
      row :comment
      row :line_items do |order|
        div class: 'admin-line-items' do
          order.line_items.each do |item|
            div class: 'line-item' do
              div class: 'section-left' do
                image_tag(item.product.images[0] ? item.product.images[0].url(:thumb) : image_url('no-image.png'),
                          width: 256)
              end
              div class: 'section-right' do
                div do
                  link_to "Title: #{item.product.title}", admin_product_path(item.product)
                end
                div do
                  "Quantity: #{item.quantity}"
                end
                div do
                  "Price: #{number_to_currency(item.product.price, unit: 'грн', format: '%n %u')}"
                end
                div do
                  "Total Price: #{number_to_currency(item.total_price, unit: 'грн', format: '%n %u')}"
                end
              end
            end
          end
        end
      end
    end
  end
end

