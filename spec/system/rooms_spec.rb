require 'rails_helper'

RSpec.describe "チャットルームの削除機能", type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
  end
  it 'チャットルームを削除すると、関連するメッセージが全て削除されていること' do
    #do sign in
    sign_in(@room_user.user)
    #visit to someone made chat room
    click_on(@room_user.room.name)
    #add 5 messages information on the database
    FactoryBot.create_list(:message, 5, room_id: @room_user.room.id, user_id: @room_user.user.id)
    #if you click "finish chatting button",make sure 5 messages information deleted on the database
    expect{
      find_link("チャットを終了する", href: room_path(@room_user.room)).click
    }.to change{ @room_user.room.messages.count }.by(-5)
    #make sure you are on the top page
    expect(current_path).to eq root_path
  end
end
