ActiveAdmin.register Issue do
  form do |f|
    f.inputs "Issue" do
      f.input :title
      f.input :description
      f.input :end_date
      f.has_many :photos do |ff|
        ff.input :image, :as => :file
        ff.input :is_list_image, :as=> :boolean
      end
    end
    f.buttons
  end
end
