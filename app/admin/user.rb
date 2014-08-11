ActiveAdmin.register User do
  form do |f|
    f.inputs "User" do
      f.input :email
      f.input :money
      f.input :nickname
      f.input :is_push, :as => :boolean, :label => "푸쉬여부"
      f.input :is_admin, :as => :boolean, :label => "어드민여부"
    end
    f.buttons
  end
end
