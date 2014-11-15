class AddLastKakaoRewardDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kakao_reward_date, :date
  end
end
