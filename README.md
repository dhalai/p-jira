Project description
---

This project is related to [the async architecture course](https://education.borshev.com/architecture)


How to run it
---

TODO: dockerize all services

1. Run kafka & zookeeper: `docker-compose build & docker-compose up`
2. Run the auth service: `cd auth & bundle install & bundle exec rails s`
3. Open the [auth UI](http://localhost:3000) and add auth credentials for all services
4. Add created credentials to all services (.env files)
5. Run the task-tracker service `cd task-tracker & bundle install & bundle exec rails s -p 3001`
6. Run the task-tracker karafka `cd task-tracker & bundle install & bundle exec karafka s`
7. Run the accounting service `cd accounting & bundle install & bundle exec rails s -p 3002`
8. Run the accounting service karafka `cd accounting & bundle install & bundle exec karafka s`
9. Run the analytics service `cd analytics & bundle install & bundle exec rails s -p 3003`
10. Run the analytics service karafka `cd analytics & bundle install & bundle exec karafka s`
11. Run the notifications service karafka `cd notifications & bundle install & bundle exec karafka s`
12. Play with the [auth](http://localhost:3000), [task-tracker](http://localhost:3001), [accounting](http://localhost:3002), and [analytics](http://localhost:3003) UI.


Event storming diagrams
---


![Event storming - tasks management](https://user-images.githubusercontent.com/453727/111066103-a2350080-84bd-11eb-8b75-cdedda616966.jpg)


![Event storming - accounting](https://user-images.githubusercontent.com/453727/111066114-a7924b00-84bd-11eb-9ccb-21d222b6829d.jpg)


![Event storming - analytics](https://user-images.githubusercontent.com/453727/111066117-aeb95900-84bd-11eb-98bb-20123e898626.jpg)


![Event stormin - auth](https://user-images.githubusercontent.com/453727/111066125-b547d080-84bd-11eb-9b29-941b85fe9226.jpg)


![Event storming - data model](https://user-images.githubusercontent.com/453727/113508310-91712b00-954f-11eb-8ca7-822f0f6cf41c.jpg)



Domain + service model
---

![domain model with events](https://user-images.githubusercontent.com/453727/113508317-9afa9300-954f-11eb-9c35-63ea798a71aa.jpg)


[P Jira event storming.pdf](https://github.com/dhalai/p-jira/files/6136525/P.Jira.event.storming.pdf)


Related miro link: https://miro.com/app/board/iXjVOf1ZEpo=/
