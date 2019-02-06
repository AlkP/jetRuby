# JetRuby

Задание содержится в файле JetRuby.pdf. 

Кратко: система управлением бизнес встречами. С удаленным api, напоминаниями и логированием.
Front - bootstrap. back - rails.


Выполнялось и тестировалось для 
* Ruby 2.3.3.
* Postgresql server 9.6
* RedisServer 3.0.6

Разворачивания:
1. rake db:drop && rake db:create && rake db:migrate
2. rails s
3. sidekiq

Аутентификация + Авторизация реализованы с помощью таких гемов как devise и pundit соответственно. 
Данное связка выбрана за простоту реализации, распространненость, поддержку.

токен для api генерируется в пункте меню при входе под пользователем


API
index (список всех подтвержденных встреч пользователя или за дату)
http://localhost:3000/app_api?token=CyVRIvbFRdgoIp2DUaI2OA
http://localhost:3000/app_api?token=CyVRIvbFRdgoIp2DUaI2OA&date=2019.02.03

new (GET, создать новое задание, для убобства тестирования, можно на POST и перенести на create) 
http://localhost:3000/app_api/new?token=CyVRIvbFRdgoIp2DUaI2OA&title=test 1&body=TestBody 1&app_time=2019.02.05 17:45:21


