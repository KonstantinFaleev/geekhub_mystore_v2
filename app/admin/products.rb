ActiveAdmin.register Product do
  ActiveAdmin.register Product do
    permit_params :name, :description, :price, images: []

    index do
      selectable_column
      id_column
      column :title
      column :price do |product|
        number_to_currency(product.price, unit: 'грн', format: '%n %u')
      end
      column :description
      column :images do |product|
        div class: 'image-list' do
          product.images.each do |image|
            div class: 'image' do
              image_tag(image.url(:mini))
            end
          end
        end
      end
      actions
    end

    show do
      attributes_table do
        row :title
        row :description
        row :price do |product|
          number_to_currency(product.price, unit: 'грн', format: '%n %u')
        end
        row :images do
          div do
            product.images.each do |image|
              div do
                image_tag(image.url(:thumb))
              end
            end
          end
        end
      end
    end

    form html: { multipart: true } do |f|
      f.semantic_errors

      f.inputs do
        f.input :title
        f.input :description
        f.input :price
        f.input :images, as: :file, input_html: { multiple: true }
      end

      actions
    end
  end

end
