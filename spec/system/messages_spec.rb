require 'rails_helper'

RSpec.describe "メッセージ投稿機能", type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
  end

  context '投稿に失敗した時' do
    it '送る値が空のため、メッセージの送信に失敗すること' do
      #do sign in
      sign_in(@room_user.user)
      #visit to the someone made chat room
      click_on(@room_user.room.name)
      #make sure doesn't save on the database
      expect{
        find('input[name="commit"]').click
      }.not_to change{ Message.count }
      #make sure come back same page
      expect(current_path).to eq room_messages_path(@room_user.room)
    end
  end
  context '投稿に成功した時' do
    it 'テキストの投稿すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      #do sign in
      sign_in(@room_user.user)
      #visit to the someone made chat room
      click_on(@room_user.room.name)
      #input the value on form
      post = "テスト"
      fill_in 'message_content', with: post
      #make sure you send the value saves on the database
      expect{
        find('input[name="commit"]').click
      }.to change{ Message.count}.by(1)
      #make sure you are on the posts list page
      expect(current_path).to eq room_messages_path(@room_user.room)
      #make sure you send the value show up on the browser
      expect(page).to have_content(post)
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      #do sign in
      sign_in(@room_user.user)
      #visit to the someone made chat room
      click_on(@room_user.room.name)
      #define image you attatch
      image_path = Rails.root.join('public/images/test_image.png')
      #attatching image on the image choosing form
      attach_file('message[image]',image_path, make_visible: true)
      #make sure save on the database you send the value
      expect{
        find('input[name="commit"]').click
      }.to change{ Message.count}.by(1)
      #make sure you are on the posts list page
      expect(current_path).to eq room_messages_path(@room_user.room)
      #make sure the image show up on the browser 
      expect(page).to have_selector("img")
    end

    it 'テキストと画像の投稿に成功すること' do
      #do sign in
      sign_in(@room_user.user)
      #visit to the someone made chat room
      click_on(@room_user.room.name)
      #define image you attatch
      image_path = Rails.root.join('public/images/test_image.png')
      #attatching image on the image choosing form
      attach_file('message[image]',image_path, make_visible: true)
      #input the text on the text form
      post = "テスト"
      fill_in 'message_content', with: post
      #make sure you send the value save on the databese
      expect{
        find('input[name="commit"]').click
      }.to change{ Message.count}.by(1)
      #make sure showing up you send the value on the browser
      expect(page).to have_content(post)
      #make sure showing up you send the image on the browser
      expect(page).to have_selector("img")
    end
  end
end
