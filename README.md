## Coderetreat でペアプロの相手を適当に決める

## 使い方

### 方法1: CSVファイルを読み込んで使う

http://cr4g.herokuapp.com
にアクセスし、CSVファイルを読み込ませれば適当に割り振ります。

### 方法2: Google spreadsheetを使う

http://cr4g.herokuapp.com/events/new
にアクセスし、以下の情報を登録します。
1. イベント用のアカウント（英数字でお願いします。URLに使用します）
2. イベント名（日本語でも大丈夫）
3. Google spreadsheetのID（読み込み可能な状態にしておいてください）

そのあとは http://cr4g.herokuapp.com/event/(アカウント名) にアクセスすれば、google spreadsheetを読み込んでペアリングします。

## このソースコードを使って自分で運用する際の注意
普通のrailsの構成ですが、google apiを使うので以下の環境変数を登録してください。
```
GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET
```

(これらの認証情報の取得方法は割愛。後ほど余裕があったら書きます）
