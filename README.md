# Ordering

## Usage

### Setup

```
$ make init
```

### Run (on development)

```
$ make up
```

### Production(no check)

```
$ make pinit

# docker-compose.yml(41)
- bundle exec rails s
+ bundle exec rails s -e production

# console
$ make up
```

## Refs

- [Build a RESTful JSON API with Rails5](https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one)
- [has many through with another name](https://stackoverflow.com/questions/42027822/rails-has-many-through-with-same-model)
- [Constants hash](https://stackoverflow.com/questions/818062/rails-constants-hash)
- [select_tag](https://apidock.com/rails/ActionView/Helpers/FormTagHelper/select_tag)
- [form_for checkbox](https://qiita.com/chocoken517/items/6efb9c5a1b035f9a50fa)
- [form_tag checkbox](https://www.sejuku.net/blog/27132)
- [**form with calendar on rails**](https://qiita.com/yatakan/items/3a359b2beef28fedb3c5)
- [input date styling](https://css-tricks.com/prefilling-date-input/)
- [turbolinks + jquery loading](https://qiita.com/azusanakano/items/1b96a2be0f967365a873)
- [Rails + Ajax おさらい](https://qiita.com/ka215/items/dfa602f1ccc652cf2888)
- [select onchange submit](https://qiita.com/act823/items/3a203f1f96e7fe52f69d)
- [form_with ref](https://techracho.bpsinc.jp/hachi8833/2017_05_01/39502)
- [Ruby variable in js.erb](https://www.quora.com/How-do-I-pass-a-Ruby-variable-to-JavaScript)
- [**よく使うRails**](https://qiita.com/rik0/items/b022c111b4ae3347926b)
- [paramsにhashやarray](http://whtiecrow.blog.shinobi.jp/rails/params%E3%81%AB%E3%83%8F%E3%83%83%E3%82%B7%E3%83%A5%E3%82%84%E9%85%8D%E5%88%97%E3%82%92%E4%BD%BF%E3%81%86)
- [select - リファレンス](http://railsdoc.com/references/select)
- [Request spec - RSpec](https://relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec)
- [RSpec generator setting](https://qiita.com/yuta-ushijima/items/ffb34823b8bba2180c94)

## Docker refs

- [Docker compose base sample](http://post.simplie.jp/posts/114)
- [install gem nokogiri on Docker](https://github.com/gliderlabs/docker-alpine/issues/53)
- [Set timezone on alpine](https://qiita.com/dtan4/items/8359e389b95cbc60952d)
- [Rails server still running problem](https://stackoverflow.com/questions/35022428/rails-server-is-still-running-in-a-new-opened-docker-container)
- [Nginx setting ref1](https://qiita.com/eighty8/items/0288ab9c127ddb683315#nginx%E8%A8%AD%E5%AE%9A%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB)
- [Nginx setting ref2](https://qiita.com/eighty8/items/0288ab9c127ddb683315#nginx%E8%A8%AD%E5%AE%9A%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB)
- [Rails puma with unix socket](https://qiita.com/eighty8/items/0288ab9c127ddb683315#nginx%E8%A8%AD%E5%AE%9A%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB)
- [named volumes](https://github.com/docker/compose/issues/4675)

## Travis CI refs
- [Travis CIでDocker](https://qiita.com/niisan-tokyo/items/2f4a0c904a7c6bfcc367)
- [Travis with Docker](https://docs.travis-ci.com/user/docker/)
