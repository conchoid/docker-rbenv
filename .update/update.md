# Dockerfile ベースイメージ更新手順

## 概要
docker-rbenv/3.3-bookworm/Dockerfileのベースイメージを `ruby:3.3.5-slim-bookworm` (Debian 12) から `ruby:3.3.10-slim-trixie` (Debian 13) に更新する。

## 更新手順

### 1. ベースイメージの更新
Dockerfileの1行目を以下のように変更する：

**変更前:**
```dockerfile
FROM ruby:3.3.5-slim-bookworm
```

**変更後:**
```dockerfile
FROM ruby:3.3.10-slim-trixie
```

**注意:** `ruby:3.3.5-slim-trixie` タグが存在しないため、`ruby:3.3.10-slim-trixie` を使用する。

### 2. 動作確認
以下のコマンドでDockerイメージをビルドし、正常に動作することを確認する：

```bash
cd docker-rbenv
docker build -t conchoid/docker-rbenv:v1.3.2-1-3.3.10-trixie -f 3.3-trixie/Dockerfile .
```

**注意:** rbenvのバージョンはv1.3.2を使用する。

### 3. 互換性チェック
Debian 13への更新により、以下の点を確認する：

- パッケージの互換性（apt-getでインストールしているパッケージが利用可能か）
- rbenvの動作確認
- ruby-buildの動作確認
- Ruby各バージョン（3.0.7, 3.1.7, 3.2.9, 3.3.10）のインストール確認
- bundlerのインストール確認
- ロケール設定の確認
- libssl1.0-devのインストール確認（Ubuntu bionic-securityリポジトリからの取得）

### 4. テスト実行
実際のRubyプロジェクトでイメージを使用し、以下を確認する：

- ビルドが正常に完了するか
- 依存関係の解決が正常に行われるか
- 実行時エラーが発生しないか
- rbenvによるRubyバージョン切り替えが正常に動作するか

## 注意事項
- Debian 13 (trixie) は比較的新しいリリースのため、一部のパッケージやツールのバージョンが変更されている可能性がある
- 問題が発生した場合は、パッケージのバージョン指定や代替パッケージの検討が必要になる場合がある
- **apt-getでインストールしているライブラリは必要なライブラリなので、trixieでもインストールを行う必要がある**
- libssl1.0-devはUbuntu bionic-securityリポジトリから取得しているため、trixieでも同様の設定が必要か確認すること
- ビルド後は、rbenv、ruby-build、各Rubyバージョン、bundlerが正常にインストールされていることを確認すること

