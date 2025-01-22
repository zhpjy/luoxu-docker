# luoxu docker
[落絮](https://github.com/lilydjwg/luoxu)（索引 Telegram 群组与频道的 userbot） docker 部署方案

## 使用说明
部署前需要准备好 telegram api的 id 和 key
1. 修改落絮后端配置： 参考 config.toml.example 在 config.toml 中的配置好 telegram 的 id 和 key，按需配置好代理
2. 修改落絮前端的地址： 修改 .env 文件中的端口和地址
3. 编译 docker 镜像： 执行 ```docker compose build``` 如果需要代理则执行 ```docker compose build --build-arg  https_proxy="http://1.2.3.4:1080```
4. 获取群组ID： 执行 ```docker compose run -it luoxu-backend /usr/bin/python3 -m luoxu.ls_dialogs```，按提示登陆telegram，登陆成功后会打印所有 telegram 群组id
5. 配置并启动落絮： 在 config.toml 中配置需要索引消息的群组，执行 ```docker compose up -d```

## 数据库维护
### 分区维护
每年需要手动维护一次增加分区
```
#进入数据库镜像
sudo docker compose exec -it database bash
#进入数据库
psql -U PGroonga -d luoxu
#执行函数
SELECT init_message_partitions();
#退出数据库
exit
#退出容器
exit
```
