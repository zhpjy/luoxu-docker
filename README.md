# luoxu docker
[luoxu](https://github.com/lilydjwg/luoxu) docker 镜像

可以按需自行修改构建

推荐使用 docker-compose 部署

## docker-compose 部署说明
部署前需要准备好 telegram api的 id 和 key

1. 克隆本仓库到当前目录 ```git clone --depth 1 -b master https://github.com/zhpjy/luoxu-docker.git .```
1. 启动数据库 ```sudo docker-compose up -d db``` 数据库会自动初始化，执行数据库初始化语句。执行 ```sudo docker-compose logs db``` 看到 ```PostgreSQL init process complete; ready for start up.``` 代表数据库初始化结束
1. 修改 config.toml 中的配置，执行 ```sudo docker-compose run luoxu-back /usr/bin/python3 -m luoxu.ls_dialogs``` 登录 telegram 同时查看群组id
1. 在 config.toml 中配置好需要索引消息的群组，执行 ```sudo docker-compose up -d```
1. （可选）自行配置并编译前端，在 docker-compose.yml 中追加下面内容（供参考）
    ```
    luoxu-frontend:
        image: danjellz/http-server
        volumes:
        - ./public:/public
        ports:
        - 8080:80
        restart: unless-stopped
        command: http-server -p 80 --proxy http://luoxu-backend:9008
        links:
        - "luoxu-backend:backend"
    ```
