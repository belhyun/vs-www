ActiveAdmin.register Issue do
  form do |f|
    f.inputs "Issue" do
      f.input :title
      f.input :description
      f.input :end_date
      f.input :money, :label => "이슈머니"
      f.input :is_closed, :as => :boolean, :label => "정산시작여부"
      f.has_many :photo do |cf|
        cf.input :image
      end
      f.has_many :stocks, :allow_destroy => true do |cf|
        cf.input :name
        cf.input :description
        cf.input :money
        cf.input :is_win, :as=> :boolean
        cf.has_many :photo do |cff|
          cff.input :image
        end
      end
    end
    f.buttons
  end
end
