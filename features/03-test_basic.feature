# -*- coding: utf-8 -*-
Feature: 簡単なテスト(正常系)を一通り実行する
    まず、使う枚数を2枚に設定する
    「テスト開始」ボタンを押し、テスト画面に遷移
    1首目の決まり字を入力し「これで決まり！」ボタンをタップすると、2枚目に移る
    2首目の決まり字を入力し「これで決まり！」ボタンをタップすると、テスト終了画面が出る

  Scenario: テスト対象の歌を2首に指定し、テストを実行する。
    Given I am on the StartScreen
    Then I wait to see a navigation bar titled "トップ"
    # まず、使う枚数を2枚に設定する
    Then I touch "number_of_poems"
    Then I should see "使う枚数"
    Then I select 2
    Then I go back
    Then I wait to see "2首"
    # 「テスト開始」ボタンを押し、テスト画面に遷移
    Then I touch "start_test"
    Then I should see text starting with "1/"
    # 1首目の決まり字を入力し「これで決まり！」ボタンをタップすると、2枚目に移る
    Then I input correct kimariji
    Then I touch "challenge_button"
    Then I should see text starting with "2/"
    # 2首目の決まり字を入力し「これで決まり！」ボタンをタップすると、完了画面が出る
    Then I input correct kimariji
    Then I touch "challenge_button"
    Then I see the "complete_view"
    # ホームに戻るボタンを押すと、ホーム画面に戻る
    Then I touch "return_button"
    Then I wait to see a navigation bar titled "トップ"
