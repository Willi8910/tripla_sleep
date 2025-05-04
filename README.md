Strategy to handle large volume user base

When user base is growing larger and can have tens millions of data, I plan to handle this using this approach below:
- Using partition at the sleep record table: Partition is a good approach to handle large amount of data in RDBMS. Since we heavily filter the record by date, I put this as partition target. Every month we will have sidekiq cron to manually generate partition cluster for sleep record to make it recorded seamlessly.
- Indexing in sleep record table. We have several ways to show and search the sleep record. We must put index for whichever field is needed to search the record, for instance is user_id, created_at, and interval
- Add tabulation on fething following user. When we fetch following user sleep record, we also need to get the user information. We can achieve this by using includes logic, however if the user base is large it's may still cause long query that cause slowness. Another approach which is tabulation that we fetch following user first and put into hash, and we deliberately add this into serializer so we don't need to burden more logic into rails anymore
- Clock out worker. I put worker in clock out, since this logic is considerably heavier that clock in. We must calculate interval and time range field, additionally takes time to indexing for DB. With that in mind, better to put this eventual consistency rather than make user waiting for too long

Project structure

For this project structure, I separate between logic and controller layer. Assuming this project will become a long term project where we need to add feature time by time, it's better to separate usage of logics. Heavy logics placed in Service directory, as well as filter and sorting file. This will make then reusable and way more easier to maintain in long term period. The downside is it's somewhat complicated to someone not used of this kind of structure. Serializer is the same as rails serializer in general.

JSON schema

As instructed, I used restful API to implement this, so this is rails api only project. this is the postman collection for this project
JSON request collection

[Tripla API Collection.json](https://github.com/user-attachments/files/20026508/Tripla.Collection.json)


Test cases

I use rspec gem to implement this, I make sure this project is 100% code coveraged. The test cases covers for all controllers, models, and services. I don't test each of services individually. But I include it in controller test cases result

Requirement which is not cleared:

- How is the clock in and clock out inserted?
It's when the user call the API right at that time
