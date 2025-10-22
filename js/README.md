Docker 部署 Sub-Store：docker run -it -d --restart=always -e "SUB_STORE_CRON=50 23 *" -e SUB_STORE_FRONTEND_BACKEND_PATH=/T3B9dgzBzdRbBF8Aqx7P -p 3008:3001 -v /etc/sub-store:/opt/app/data --name Sub2Store xream/sub-store:latest

访问地址：http://10.0.0.3:3008/?api=http://10.0.0.3:3008/T3B9dgzBzdRbBF8Aqx7P

<img width="978" height="578" alt="image" src="https://github.com/user-attachments/assets/2944cb4f-bbdb-4350-9ed9-66bbe5fa4e12" />
