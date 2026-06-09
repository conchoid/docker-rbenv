# 4.0-trixie 更新手順

更新日: 2026-04-01

## 1. ベースディレクトリを複製

`3.3-trixie` を複製して `4.0-trixie` を作成した。

```bash
cp -a /home/oik/go/src/github.com/conchoid/docker-rbenv/3.3-trixie \
  /home/oik/go/src/github.com/conchoid/docker-rbenv/4.0-trixie
```

## 2. 採用したバージョン

- ベースイメージ: `ruby:4.0.2-slim-trixie`
- `RBENV_VERSION`: `v1.3.2`
- `RUBY_BUILD_VERSION`: `v20260327`
- `bundler`: `4.0.9`
- プレインストール Ruby:
- `3.2.11`
- `3.3.11`
- `3.4.9`

## 3. バージョン確認の根拠

### Ruby 系列のメンテナンス状況

Ruby 公式の Maintenance Branches を確認し、2026-04-01 時点で EOL から 1 年を超えていない系列、またはまだサポート中の系列として `3.2`, `3.3`, `3.4` を採用した。

- Ruby 3.2: `security maintenance`, EOL は `2026-03-31 (expected)`
- Ruby 3.3: `normal maintenance`
- Ruby 3.4: `normal maintenance`

最新メンテナンス版は Ruby Releases から確認した。

- `3.2.11`
- `3.3.11`
- `3.4.9`
- ベース用 `4.0.2`

確認 URL:

- https://www.ruby-lang.org/en/downloads/branches/
- https://www.ruby-lang.org/en/downloads/releases/

### bundler

RubyGems の `bundler` バージョン一覧 API を確認し、最新安定版は `4.0.9`、required Ruby version は `>= 3.2.0` だった。今回プレインストールする `3.2`, `3.3`, `3.4` とベースの `4.0.2` で共通利用可能な最新版として `4.0.9` を採用した。

確認 URL:

- https://rubygems.org/gems/bundler/versions/
- https://rubygems.org/api/v1/versions/bundler.json

### ruby-build

GitHub Releases の latest を確認し、`ruby-build` の最新は `v20260327` だった。

確認 URL:

- https://github.com/rbenv/ruby-build
- https://api.github.com/repos/rbenv/ruby-build/releases/latest

### rbenv

GitHub Releases の latest を確認し、`rbenv` の最新は `v1.3.2` だった。

確認 URL:

- https://github.com/rbenv/rbenv.git
- https://api.github.com/repos/rbenv/rbenv/releases/latest

## 4. Dockerfile の変更内容

`/home/oik/go/src/github.com/conchoid/docker-rbenv/4.0-trixie/Dockerfile` を更新した。

- `FROM ruby:4.0.2-slim-trixie` に変更
- `RUBY_BUILD_VERSION` を `v20260327` に更新
- `bundler` を `4.0.9` に更新
- プレインストール Ruby を `3.2.11`, `3.3.11`, `3.4.9` に更新
- 今回の対象 Ruby では不要なため、旧 `libssl1.0-dev` 追加設定を削除

## 5. タグ番号の決定

Docker Hub のタグ一覧を確認した。

- 既存タグに `v1.3.2-1-4.0.2-trixie` は存在しなかった
- そのため連番は `1` を採用

確認 URL:

- https://hub.docker.com/repository/docker/conchoid/docker-rbenv/tags
- https://hub.docker.com/v2/repositories/conchoid/docker-rbenv/tags?page_size=100

採用タグ:

```text
conchoid/docker-rbenv:v1.3.2-1-4.0.2-trixie
```

## 6. ビルド

以下でビルドを実施した。

```bash
docker build -t conchoid/docker-rbenv:v1.3.2-1-4.0.2-trixie \
  /home/oik/go/src/github.com/conchoid/docker-rbenv/4.0-trixie
```

ビルド結果:

- 成功
- image id: `sha256:541ff83ef5a01d467092e5151fae48d953e3a49e0b55c834ad17a44c48b1195f`

ローカル確認:

```bash
docker images --format '{{.Repository}}:{{.Tag}} {{.ID}} {{.Size}}' | \
  rg '^conchoid/docker-rbenv:v1\.3\.2-1-4\.0\.2-trixie '
```

確認結果:

```text
conchoid/docker-rbenv:v1.3.2-1-4.0.2-trixie 541ff83ef5a0 789MB
```
