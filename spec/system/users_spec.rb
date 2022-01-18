require 'rails_helper'

RSpec.describe "新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザ新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページへ遷移する' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'nickname', with: @user.nickname
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      fill_in 'password-confirmation', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'nickname', with: ""
      fill_in 'email', with: ""
      fill_in 'password', with: ""
      fill_in 'password-confirmation', with: ""
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        find('input[name=commit]').click
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq user_registration_path
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content("ログイン")
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click 
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content("ログイン")
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'email', with: ""
      fill_in 'password', with: ""
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe '編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @user2 = FactoryBot.build(:user)
  end

  context '編集ができるとき' do
    it '正しい情報を入力すれば、ユーザー情報を変更できる' do
      # ログインする
      sign_in(@user)
      # トップページへ遷移する
      visit root_path
      # トップページに編集ページへ遷移するボタンがあることを確認する
      expect(page).to have_content("#{@user.nickname}")
      # 編集ページへ遷移する
      visit edit_user_registration_path
      # 正しいユーザー情報を入力する
      fill_in 'nickname', with: @user2.nickname
      fill_in 'email', with: @user2.email
      fill_in 'password', with: @user2.password
      fill_in 'password-confirmation', with: @user2.password_confirmation
      fill_in 'current-password', with: @user.password
      # 変更ボタンを押す
      find('input[name="commit"]').click 
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # ユーザーの変更後のニックネームボタンが表示されることを確認する
      expect(page).to have_content("#{@user2.nickname}")
    end
  end
  context '編集できないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # ログインする
      sign_in(@user)
      # トップページへ遷移する
      visit root_path
      # トップページに編集ページへ遷移するボタンがあることを確認する
      expect(page).to have_content("#{@user.nickname}")
      # 編集ページへ遷移する
      visit edit_user_registration_path
      # ユーザー情報を入力する
      fill_in 'nickname', with: ""
      fill_in 'email', with: ""
      fill_in 'password', with: @user2.password
      fill_in 'password-confirmation', with: @user2.password_confirmation
      fill_in 'current-password', with: @user.password
      # 変更ボタンを押す
      find('input[name="commit"]').click
      # 元の編集ページに戻されていることを確認する
      expect(current_path).to eq(user_registration_path)
    end
  end
end

RSpec.describe '削除', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ユーザー削除完了まで' do
    it '退会ボタンを押せば、ユーザーが退会することができる' do
      # ログインする
      sign_in(@user)
      # トップページに編集ページへ遷移するボタンがあることを確認する
      expect(page).to have_content("#{@user.nickname}")
      # 編集ページへ遷移する
      visit edit_user_registration_path
      # 退会ボタンを押す
      page.accept_confirm do
        click_on :cancel_btn
      end
      # ユーザーモデルのdeleted_atカラムがnullではないことが確認できる
      # データベースが処理完了するまで待機
        # sleep 0.1
        # expect(User.find_by(id: @user.id).deleted_at.present?).to be true 
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていることを確認する
      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')
    end
  end
  context 'ユーザー削除後の新規登録' do
    it '一度削除されたユーザーのものであれば、同じメールアドレスでもログインできる' do
      # ログインする
      sign_in(@user)
      # ユーザー削除する
      delete_user(@user)
      # 同じメールアドレスを使って新規登録する
      fill_in 'nickname', with: @user2.nickname
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      fill_in 'password-confirmation', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
    end
  end
  context '削除したユーザーのログイン失敗' do
    it '一度削除されたユーザー情報ではログインできない' do
      # ログインする
      sign_in(@user)
      # ユーザー削除する
      delete_user(@user)
      # もう一度同じユーザー情報でログインする
      visit new_user_session_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end