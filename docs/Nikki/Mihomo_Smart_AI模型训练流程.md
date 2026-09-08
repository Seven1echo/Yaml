# Mihomo_Smart_AI模型训练流程



## 一、 数据收集及提取
1. 修改 Yaml Smart 策略组的 **collectdata** 参数为 **True** ，开启数据收集。建议持续收集数据 **一周以上**，也可阶段性数据收集，基于使用数据更新模型  
<img width="1382" height="167" alt="image" src="https://github.com/user-attachments/assets/b2ee0077-a54c-4285-b04a-e437b2cd21d2" />  

2. 提取 smart_weight_data.csv 至生产环境  
终端登录 Openwrt: **/etc/nikki/run/** ,下载 smart_weight_data.csv 文件到本地
<img width="807" height="400" alt="image" src="https://github.com/user-attachments/assets/376c96a4-98ed-4bf1-9151-7e8a2490c8a4" />  



## 二、 使用 [**Mihomo_Smart_AI模型训练工具.exe**](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/config/smart/Mihomo_Smart_AI%E6%A8%A1%E5%9E%8B%E8%AE%AD%E7%BB%83%E5%B7%A5%E5%85%B7.exe) 制作 **Model.bin**
1. 打开训练工具后，点击 **浏览** ，选取 smart_weight_data.csv 文件   

2. 点击 **开始训练** ，静待程序跑批完毕，Model.bin 将会生成在桌面  
<img width="948" height="470" alt="image" src="https://github.com/user-attachments/assets/ef8c1213-4c45-4c94-bd88-1571dca55306" />  

3. 上传 Model.bin 至 OpenWrt：**/etc/nikki/run/** ，正常使用即可
<img width="317" height="348" alt="image" src="https://github.com/user-attachments/assets/4234cfe3-fe56-47f6-a8dc-bb5270a647d4" />






