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
      f.has_many :stocks, :allow_destroy => true do |cf|
        cf.input :name
        cf.input :description
        cf.input :money
        cf.input :is_win, :as=> :boolean
      end
    end
    f.buttons
  end
end
