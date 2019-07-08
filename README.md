## Coderetreat でペアプロの相手を適当に決める

## 使い方
方法1: CSVファイルを読み込んで使う
http://(hostname)
にアクセスし、CSVファイルを読み込ませれば適当に割り振ります。

方法2: Google spreadsheetを使う
http://(hostname)/event/new
にアクセスし、以下の情報を登録します。
1. イベント用のアカウント（英数字でお願いします。URLに使用します）
2. イベント名（日本語でも大丈夫）
3. Google spreadsheetのID（読み込み可能な状態にしておいてください）

そのあとは http://(hostname)/event/(アカウント名) にアクセスすれば、google spreadsheetを読み込んでペアリングします。

