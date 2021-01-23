require 'rails_helper'

RSpec.describe "ユーザーログイン機能", type: :system do

  it 'ログインしていない状態でトップページにアクセスした場合、サインインページに移動する' do
    #visit to top page
    visit root_path
    #if you didn't logged in, make sure you are on the signin page
    expect(current_path).to eq new_user_session_path
  end

  it 'ログインに成功し、トップページに遷移する' do
    #save user on the database at first
    @user = FactoryBot.create(:user)
    #move to signin page
    visit new_user_session_path
    #if didn't logged in, make sure you are on the signin page
    expect(current_path).to eq new_user_session_path
    #input user's email and password from already exist user
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    #click the logged in button
    click_on("Log in")
    #make sure you are on the top page
    expect(current_path).to eq root_path
  end

  it 'ログインに失敗し、再びサインインページに戻ってくる' do
    #save user on the database at first
    @user = FactoryBot.create(:user)
    #visit to top page
    visit root_path
    #if you didn't logged in, make sure you are on the sign in page
    expect(current_path).to eq new_user_session_path
    #input wrong user data
    fill_in 'user_email', with: "test"
    fill_in 'user_password', with: "test"
    #click logged in button
    click_on("Log in")
    #make sure come back to the sign in page
    expect(current_path).to eq new_user_session_path
  end
end

  
